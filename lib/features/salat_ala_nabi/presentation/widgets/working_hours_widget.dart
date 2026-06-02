import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/custom_working_hour_option.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/working_hour_option_item.dart';

class WorkingHoursWidget extends StatelessWidget {
  const WorkingHoursWidget({
    required this.settings,
    this.onModeChanged,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    super.key,
  });

  final ReminderSettingsModel settings;
  final ValueChanged<int>? onModeChanged;
  final void Function(int hour, int minute)? onStartTimeChanged;
  final void Function(int hour, int minute)? onEndTimeChanged;

  Future<void> _selectCustomTime(
    BuildContext context,
    bool isStart,
    TimeOfDay initialTime,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: AppStrings.selectTime,
      cancelText: AppStrings.cancel,
      confirmText: AppStrings.ok,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.secondaryBackground,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.secondaryBackground,
              hourMinuteTextColor: AppColors.textPrimary,
              dayPeriodTextColor: AppColors.textPrimary,
              dialHandColor: AppColors.primary,
              dialBackgroundColor: AppColors.scaffoldBackground,
              hourMinuteColor: AppColors.scaffoldBackground,
              dayPeriodColor: AppColors.scaffoldBackground,
              dayPeriodTextStyle: AppTextStyles.font16W700White(context),
              helpTextStyle: AppTextStyles.font16W700primary(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked != null && context.mounted) {
      unawaited(AppFeedback.playVibrate());
      if (isStart) {
        onStartTimeChanged?.call(picked.hour, picked.minute);
      } else {
        onEndTimeChanged?.call(picked.hour, picked.minute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMode = settings.workingHoursMode;
    final startTime = TimeOfDay(
      hour: settings.startHour,
      minute: settings.startMinute,
    );
    final endTime = TimeOfDay(
      hour: settings.endHour,
      minute: settings.endMinute,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.reminderWorkingHours,
          style: AppTextStyles.font16W700White(context),
        ),
        const SizedBox(height: AppSpacing.v18),
        WorkingHourOptionItem(
          title: AppStrings.allDay,
          isSelected: selectedMode == WorkingHoursMode.allDay,
          onTap: onModeChanged != null
              ? () {
                  unawaited(AppFeedback.playVibrate());
                  onModeChanged!(WorkingHoursMode.allDay);
                }
              : () {},
        ),
        const SizedBox(height: AppSpacing.v12),
        WorkingHourOptionItem(
          title: AppStrings.from10amTo10pm,
          isSelected: selectedMode == WorkingHoursMode.defaultHours,
          onTap: onModeChanged != null
              ? () {
                  unawaited(AppFeedback.playVibrate());
                  onModeChanged!(WorkingHoursMode.defaultHours);
                }
              : () {},
        ),
        const SizedBox(height: AppSpacing.v12),
        CustomWorkingHourOption(
          isSelected: selectedMode == WorkingHoursMode.custom,
          startTimeText: settings.formattedStartTime,
          endTimeText: settings.formattedEndTime,
          onModeTap: onModeChanged != null
              ? () {
                  unawaited(AppFeedback.playVibrate());
                  onModeChanged!(WorkingHoursMode.custom);
                }
              : () {},
          onStartTimeTap: onStartTimeChanged != null
              ? () => _selectCustomTime(context, true, startTime)
              : () {},
          onEndTimeTap: onEndTimeChanged != null
              ? () => _selectCustomTime(context, false, endTime)
              : () {},
        ),
      ],
    );
  }
}


