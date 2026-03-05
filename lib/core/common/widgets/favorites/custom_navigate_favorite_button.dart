import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomNavigateFavoriteButton extends StatelessWidget {
  const CustomNavigateFavoriteButton({
    required this.onPressed,
    super.key,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(SolarIconsBold.heart, color: AppColors.gold),
      onPressed: onPressed,
    );
  }
}
