import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';

class CustomWorkingHourOption extends StatelessWidget {
  const CustomWorkingHourOption({
    required this.isSelected,
    required this.startTimeText,
    required this.endTimeText,
    required this.onModeTap,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
    super.key,
  });

  final bool isSelected;
  final String startTimeText;
  final String endTimeText;
  final VoidCallback onModeTap;
  final VoidCallback onStartTimeTap;
  final VoidCallback onEndTimeTap;

  @override
  Widget build(BuildContext context) {
    return AppSelectionCard(
      title: AppStrings.selectCustomTime,
      isSelected: isSelected,
      onTap: onModeTap,
      content: Column(
        children: [
          const AppGap.h(AppSpacing.v16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
            child: Row(
              children: [
                Expanded(
                  child: _TimePickerItem(
                    label: AppStrings.from,
                    time: startTimeText,
                    onTap: onStartTimeTap,
                  ),
                ),
                const AppGap.w(AppSpacing.v12),
                Expanded(
                  child: _TimePickerItem(
                    label: AppStrings.to,
                    time: endTimeText,
                    onTap: onEndTimeTap,
                  ),
                ),
              ],
            ),
          ),
          const AppGap.h(AppSpacing.v16),
        ],
      ),
    );
  }
}

class _TimePickerItem extends StatelessWidget {
  const _TimePickerItem({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCustomItemCard(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.font12W500(
              context,
            ).copyWith(color: context.color.textSecondary),
          ),
          const AppGap.h(AppSpacing.v4),
          Text(
            time,
            style: AppTextStyles.font16W700(
              context,
            ).copyWith(color: context.color.textAccent),
          ),
        ],
      ),
    );
  }
}
