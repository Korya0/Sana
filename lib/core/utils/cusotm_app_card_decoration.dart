import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

BoxDecoration customAppCardDecoration() {
  return BoxDecoration(
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
}
