import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

BoxDecoration customAppCardDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
    color: context.color.secondary,
  );
}
