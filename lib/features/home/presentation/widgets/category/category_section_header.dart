import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class CategorySectionHeader extends StatelessWidget {
  const CategorySectionHeader({required this.title, super.key, this.child});
  final String title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.v4,
                height: AppSpacing.v20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.v4),
                ),
              ),
              const SizedBox(width: AppSpacing.v8),
              Text(title, style: AppTextStyles.font18W700White(context)),
            ],
          ),
          ?child,
        ],
      ),
    );
  }
}
