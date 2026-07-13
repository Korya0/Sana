import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class CombinedShareCopyButton extends StatefulWidget {
  const CombinedShareCopyButton({
    this.onSharePressed,
    this.onCopyPressed,
    this.hapticService,
    this.iconSize,
    super.key,
  });

  final AsyncCallback? onSharePressed;
  final VoidCallback? onCopyPressed;
  final IHapticService? hapticService;
  final double? iconSize;

  @override
  State<CombinedShareCopyButton> createState() =>
      _CombinedShareCopyButtonState();
}

class _CombinedShareCopyButtonState extends State<CombinedShareCopyButton> {
  static const Duration _kCopyIconDuration = AppConstants.hiveInitTimeout2s;
  static const Duration _kSwitcherDuration = AppConstants.animationNormal300ms;

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

    return Tooltip(
      message: isCopyOnly
          ? AppStrings.copyContent
          : (_isSharing ? AppStrings.sharingInProgress : AppStrings.combinedShareCopyTooltip),
      child: InkWell(
        onTap: () {
          if (isCopyOnly) {
            _handleCopyAction();
          } else if (!_isSharing) {
            unawaited(_handleShareAction());
          }
        },
        onLongPress: (isCopyOnly || _isSharing) ? null : _handleCopyAction,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.v8),
          child: AnimatedSwitcher(
            duration: _kSwitcherDuration,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: _isSharing
                ? _ShareSkeleton(key: const ValueKey<String>('share_skeleton'), size: iconSize)
                : Icon(
                    _showCopyIcon || isCopyOnly
                        ? SolarIconsOutline.copy
                        : SolarIconsOutline.share,
                    key: ValueKey<bool>(_showCopyIcon || isCopyOnly),
                    color: context.color.primary,
                    size: iconSize,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ShareSkeleton extends StatelessWidget {
  const _ShareSkeleton({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.color.textSecondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
      ),
    );
  }
}
