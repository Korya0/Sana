import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

BoxDecoration featureCardDecoration({
  BoxShape shape = BoxShape.rectangle,
  BorderRadiusGeometry? borderRadius,
  Color? color,
  Color? borderColor,
}) {
  final bgColor = color ?? AppColors.secondaryBackground;
  return BoxDecoration(
    shape: shape,
    borderRadius: borderRadius,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        bgColor,
        bgColor.withValues(alpha: 0.8),
      ],
    ),
    border: Border.all(
      color: borderColor ?? AppColors.primary.withValues(alpha: 0.12),
    ),
  );
}
