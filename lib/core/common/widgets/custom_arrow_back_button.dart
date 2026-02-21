import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomArrowBackButton extends StatelessWidget {

  const CustomArrowBackButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.pop(),
      child: const Icon(
        SolarIconsBold.altArrowRight,
        color: AppColors.white,
        size: 24,
      ),
    );
  }
}
