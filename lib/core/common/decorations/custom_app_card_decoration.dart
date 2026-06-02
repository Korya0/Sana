import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

BoxDecoration customAppCardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
    gradient: LinearGradient(
      colors: [AppColors.secondry, AppColors.secondry.withValues(alpha: 0.15)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
