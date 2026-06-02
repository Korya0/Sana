import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:sana/core/utils/app_feedback.dart';

class LightbulbButton extends StatelessWidget {
  const LightbulbButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed != null
          ? () {
              unawaited(AppFeedback.playVibrate());
              onPressed?.call();
            }
          : null,
      icon: const Icon(SolarIconsBold.lightbulb, color: AppColors.iconAccent),
    );
  }
}

