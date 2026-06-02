import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:solar_icons/solar_icons.dart';

class CombinedShareCopyButton extends StatefulWidget {
  const CombinedShareCopyButton({
    this.onSharePressed,
    this.onCopyPressed,
    super.key,
    this.iconSize,
  });

  final VoidCallback? onSharePressed;
  final VoidCallback? onCopyPressed;
  final double? iconSize;

  @override
  State<CombinedShareCopyButton> createState() =>
      _CombinedShareCopyButtonState();
}

class _CombinedShareCopyButtonState extends State<CombinedShareCopyButton> {
  bool _showCopyIcon = false;

  void _handleCopyAction() {
    if (widget.onCopyPressed == null) return;

    unawaited(AppFeedback.playVibrate());

    widget.onCopyPressed?.call();

    if (widget.onSharePressed != null) {
      setState(() {
        _showCopyIcon = true;
      });
      unawaited(
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showCopyIcon = false;
            });
          }
        }),
      );
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
            unawaited(AppFeedback.playDoubleVibrate());
            widget.onSharePressed?.call();
          }
        },
        onLongPress: isCopyOnly ? null : _handleCopyAction,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.v8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
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

