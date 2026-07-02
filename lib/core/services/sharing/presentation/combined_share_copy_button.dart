import 'dart:async';

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

  final VoidCallback? onSharePressed;
  final VoidCallback? onCopyPressed;
  final IHapticService? hapticService;
  final double? iconSize;

  @override
  State<CombinedShareCopyButton> createState() =>
      _CombinedShareCopyButtonState();
}

class _CombinedShareCopyButtonState extends State<CombinedShareCopyButton> {
  static const _kCopyIconDuration = Duration(seconds: 2);
  static const _kSwitcherDuration = Duration(milliseconds: 300);

  bool _showCopyIcon = false;
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

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.iconSize ?? 22.r(context);
    final isCopyOnly = widget.onSharePressed == null;

    return Tooltip(
      message: isCopyOnly
          ? AppStrings.copyContent
          : AppStrings.combinedShareCopyTooltip,
      child: InkWell(
        onTap: () {
          if (isCopyOnly) {
            _handleCopyAction();
          } else {
            unawaited(_hapticService.playDoubleVibrate());
            widget.onSharePressed?.call();
          }
        },
        onLongPress: isCopyOnly ? null : _handleCopyAction,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.v8),
          child: AnimatedSwitcher(
            duration: _kSwitcherDuration,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
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
