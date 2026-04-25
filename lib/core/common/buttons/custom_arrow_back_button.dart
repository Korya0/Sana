import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomArrowBackButton extends StatelessWidget {
  const CustomArrowBackButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unawaited(AppFeedback.playLightHaptic());
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: const Icon(
        SolarIconsBold.altArrowRight,
        color: AppColors.iconWhite,
        size: 24,
      ),
    );
  }
}
