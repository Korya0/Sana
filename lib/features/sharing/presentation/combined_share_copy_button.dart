import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:solar_icons/solar_icons.dart';

class CombinedShareCopyButton extends StatefulWidget {
  const CombinedShareCopyButton({
    required this.onSharePressed,
    required this.onCopyPressed,
    super.key,
    this.iconSize,
  });

  final VoidCallback onSharePressed;
  final VoidCallback onCopyPressed;
  final double? iconSize;

  @override
  State<CombinedShareCopyButton> createState() =>
      _CombinedShareCopyButtonState();
}

class _CombinedShareCopyButtonState extends State<CombinedShareCopyButton> {
  bool _showCopyIcon = false;

  void _handleLongPress() {
    unawaited(AppFeedback.playMediumHaptic());
    unawaited(AppFeedback.playClickSound());

    widget.onCopyPressed();
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

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.iconSize ?? 22;

    return Tooltip(
      message: AppStrings.combinedShareCopyTooltip,
      child: InkWell(
        onTap: () {
          unawaited(AppFeedback.playLightHaptic());
          unawaited(AppFeedback.playClickSound());
          widget.onSharePressed();
        },
        onLongPress: _handleLongPress,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.v8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              _showCopyIcon ? SolarIconsOutline.copy : SolarIconsOutline.share,
              key: ValueKey<bool>(_showCopyIcon),
              color: AppColors.gold,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
