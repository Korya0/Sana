import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
class ReminderEmptyView extends StatelessWidget {
  const ReminderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.v24, horizontal: AppSpacing.v16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.secondaryScaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: AppSpacing.v48,
            color: context.color.textSecondary.withValues(alpha: 0.5),
          ),
          const AppGap.h(AppSpacing.v16),
          Text(
            AppStrings.noRemindersActiveForThisZikr,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14W500(context).copyWith(
              color: context.color.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
