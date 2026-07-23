import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class CombinedShareCopyButton extends StatefulWidget {
  const CombinedShareCopyButton({
    this.onSharePressed,
    this.onCopyPressed,
    this.hapticService,
    this.iconSize,
    this.builder,
    super.key,
  });

  final AsyncCallback? onSharePressed;
  final VoidCallback? onCopyPressed;
  final IHapticService? hapticService;
  final double? iconSize;
  final Widget Function(
    BuildContext context,
    // Consistent with legacy signature
    // ignore: avoid_positional_boolean_parameters
    bool isSharing,
    bool showCopyIcon,
    VoidCallback? handleShare,
    VoidCallback? handleCopy,
  )?
  builder;

  @override
  State<CombinedShareCopyButton> createState() =>
      _CombinedShareCopyButtonState();
}

class _CombinedShareCopyButtonState extends State<CombinedShareCopyButton> {
  static const Duration _kCopyIconDuration = AppConstants.hiveInitTimeout2s;

  bool _showCopyIcon = false;
  bool _isSharing = false;
  Timer? _copyTimer;
  late final IHapticService _hapticService =
      widget.hapticService ?? sl<IHapticService>();

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _handleCopyAction() {
    if (widget.onCopyPressed == null) return;

    unawaited(_hapticService.playVibrate());

    widget.onCopyPressed?.call();

    if (widget.onSharePressed != null) {
      setState(() {
        _showCopyIcon = true;
      });
      _copyTimer?.cancel();
      _copyTimer = Timer(_kCopyIconDuration, () {
        if (mounted) {
          setState(() {
            _showCopyIcon = false;
          });
        }
      });
    }
  }

  Future<void> _handleShareAction() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    unawaited(_hapticService.playDoubleVibrate());
    try {
      await widget.onSharePressed?.call();
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.iconSize ?? 22.r(context);
    final isCopyOnly = widget.onSharePressed == null;

    final handleShare = widget.onSharePressed != null
        ? () => unawaited(_handleShareAction())
        : null;

    final handleCopy = widget.onCopyPressed != null ? _handleCopyAction : null;

    if (widget.builder != null) {
      return widget.builder!(
        context,
        _isSharing,
        _showCopyIcon,
        handleShare,
        handleCopy,
      );
    }

    return Tooltip(
      message: isCopyOnly
          ? AppStrings.copyContent
          : (_isSharing
                ? AppStrings.sharingInProgress
                : AppStrings.combinedShareCopyTooltip),
      child: InkWell(
        onTap: () {
          if (isCopyOnly) {
            handleCopy?.call();
          } else if (!_isSharing) {
            handleShare?.call();
          }
        },
        onLongPress: (isCopyOnly || _isSharing) ? null : handleCopy,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.v8),
          child: ShareAnimatedIcon(
            isSharing: _isSharing,
            iconSize: iconSize,
            icon: Icon(
              _showCopyIcon || isCopyOnly
                  ? SolarIconsOutline.copy
                  : SolarIconsOutline.share,
              color: context.color.primary,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

class ShareAnimatedIcon extends StatelessWidget {
  const ShareAnimatedIcon({
    required this.isSharing,
    required this.icon,
    this.iconSize,
    super.key,
  });

  final bool isSharing;
  final Widget icon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? 22.r(context);
    return AnimatedSwitcher(
      duration: AppConstants.animationNormal300ms,
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: isSharing
          ? ShareSkeleton(
              key: const ValueKey<String>('share_skeleton'),
              size: size,
            )
          : KeyedSubtree(
              key: const ValueKey<String>('share_icon_child'),
              child: icon,
            ),
    );
  }
}

class ShareSkeleton extends StatelessWidget {
  const ShareSkeleton({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.color.textSecondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
      ),
    );
  }
}
