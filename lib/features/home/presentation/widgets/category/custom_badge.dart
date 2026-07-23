import 'package:sana/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v8,
        vertical: AppSpacing.v4,
      ),
      decoration: BoxDecoration(
        color: context.color.primary,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(AppSpacing.radiusXS),
          topLeft: Radius.circular(AppSpacing.radiusL),
        ),
      ),
      child: Text(
        AppStrings.notAccessible,
        style: AppTextStyles.font12W700(
          context,
        ).copyWith(color: context.color.scaffoldBackgroundColor),
      ),
    );
  }
}
