import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

BoxDecoration customAppCardDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
    gradient: LinearGradient(
      colors: [context.color.secondary, context.color.secondary.withValues(alpha: 0.15)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
