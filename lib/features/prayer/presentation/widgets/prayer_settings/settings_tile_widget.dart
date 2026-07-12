import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';

class SettingsTileWidget extends StatelessWidget {
  const SettingsTileWidget({
    required this.title,
    required this.onTap,
    this.icon,
    super.key,
  });
  final IconData? icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.v16,
          vertical: AppSpacing.v14,
        ),
        decoration: BoxDecoration(
          color: context.color.secondaryScaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: context.color.textPrimary, size: AppSpacing.s22.r(context)),
              const AppGap.w(AppSpacing.v16),
            ],
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font16W700(
                  context,
                ).copyWith(color: context.color.textPrimary),
              ),
            ),
            AppArrowIcon(
              size: AppSpacing.s16.r(context),
            ),
          ],
        ),
      ),
    );
  }
}
