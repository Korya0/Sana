import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class QuranCardBackground extends StatelessWidget {
  const QuranCardBackground({super.key});

  static BoxDecoration decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [AppColors.green, AppColors.green2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF1B4332).withValues(alpha: 0.4),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -10,
      bottom: -20,
      child: Icon(
        SolarIconsBold.book,
        size: 150,
        color: AppColors.white.withValues(alpha: 0.05),
      ),
    );
  }
}
