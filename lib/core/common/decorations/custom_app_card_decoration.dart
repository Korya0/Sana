import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

BoxDecoration customAppCardDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
    color: context.color.secondary,
  );
}
