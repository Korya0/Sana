import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/entities/weekday.dart';

class ReminderTile extends StatelessWidget {
  const ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
    super.key,
  });

  final ReminderEntity reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  String _formatTime(BuildContext context) {
    final time = TimeOfDay(
      hour: reminder.hour,
      minute: reminder.minute,
    );
    return time.format(context);
  }

  String _formatSubtitle() {
    switch (reminder.repeatType) {
      case RepeatType.once:
        return AppStrings.repeatOnce;
      case RepeatType.daily:
        return AppStrings.repeatDaily;
      case RepeatType.custom:
        final days = reminder.days
            .map(WeekDay.fromValue)
            .map(_getWeekdayShortLabel)
            .join('، ');
        return '${AppStrings.daysPrefix}$days';
    }
  }

  String _getWeekdayShortLabel(WeekDay day) {
    switch (day) {
      case WeekDay.monday:
        return AppStrings.mondayShort;
      case WeekDay.tuesday:
        return AppStrings.tuesdayShort;
      case WeekDay.wednesday:
        return AppStrings.wednesdayShort;
      case WeekDay.thursday:
        return AppStrings.thursdayShort;
      case WeekDay.friday:
        return AppStrings.fridayShort;
      case WeekDay.saturday:
        return AppStrings.saturdayShort;
      case WeekDay.sunday:
        return AppStrings.sundayShort;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.color.secondaryScaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.v12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTime(context),
                      style: AppTextStyles.font24W700(context).copyWith(
                        color: reminder.isEnabled
                            ? context.color.textPrimary
                            : context.color.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                    const AppGap.h(AppSpacing.v4),
                    Text(
                      _formatSubtitle(),
                      style: AppTextStyles.font14W500(context).copyWith(
                        color: reminder.isEnabled
                            ? context.color.primary
                            : context.color.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: context.color.error,
                onPressed: onDelete,
              ),
              Switch.adaptive(
                value: reminder.isEnabled,
                onChanged: onToggle,
                activeThumbColor: context.color.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
