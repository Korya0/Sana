// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/cubit/reminder_cubit.dart';
import 'package:solar_icons/solar_icons.dart';

/// Widget for selecting working hours mode
class WorkingHoursWidget extends StatelessWidget {
  const WorkingHoursWidget({super.key});

  Future<void> _selectCustomTime(
    BuildContext context,
    bool isStart,
    TimeOfDay initialTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: 'اختر الوقت',
      cancelText: 'إلغاء',
      confirmText: 'موافق',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.gold,
              surface: AppColors.secondaryBackground,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.secondaryBackground,
              hourMinuteTextColor: AppColors.white,
              dayPeriodTextColor: AppColors.white,
              dialHandColor: AppColors.gold,
              dialBackgroundColor: AppColors.scaffoldBackground,
              hourMinuteColor: AppColors.scaffoldBackground,
              dayPeriodColor: AppColors.scaffoldBackground,
              dayPeriodTextStyle: AppTextStyles.font14W600White(context),
              helpTextStyle: AppTextStyles.font16W600Gold(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.gold),
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
      final cubit = context.read<ReminderCubit>();
      if (isStart) {
        cubit.updateStartTime(picked.hour, picked.minute);
      } else {
        cubit.updateEndTime(picked.hour, picked.minute);
      }
    }
  }

  String _formatTimeWithPeriod(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'صباحاً' : 'مساءً';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderSettings?>(
      builder: (context, settings) {
        if (settings == null) return const SizedBox.shrink();

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
              'ساعات تفعيل التذكير',
              style: AppTextStyles.font16W600White(context),
            ),
            const SizedBox(height: AppSpacing.betweenSections18),

            // Option 1: طوال اليوم
            _buildWorkingHourOption(
              context: context,
              index: 0,
              title: 'طوال اليوم',
              subtitle: '24 ساعة',
              isSelected: selectedMode == 0,
            ),
            const SizedBox(height: AppSpacing.betweenSections18 - 8),

            // Option 2: 10 ص - 10 م
            _buildWorkingHourOption(
              context: context,
              index: 1,
              title: 'من 10 صباحاً إلى 10 مساءً',
              subtitle: '10 ص - 10 م',
              isSelected: selectedMode == 1,
            ),
            const SizedBox(height: AppSpacing.betweenSections18 - 8),

            // Option 3: مخصص
            _buildCustomWorkingHourOption(
              context: context,
              isSelected: selectedMode == 2,
              startTime: startTime,
              endTime: endTime,
            ),
          ],
        );
      },
    );
  }

  Widget _buildWorkingHourOption({
    required BuildContext context,
    required int index,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<ReminderCubit>().updateWorkingHoursMode(index);
      },
      child: Container(
        padding: const EdgeInsets.all((16)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withOpacity(0.15)
              : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular((12)),
          border: Border.all(
            color: isSelected
                ? AppColors.gold
                : AppColors.grey.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.font16W600White(context).copyWith(
                    color: isSelected ? AppColors.gold : AppColors.white,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                SolarIconsBold.checkCircle,
                color: AppColors.gold,
                size: (20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomWorkingHourOption({
    required BuildContext context,
    required bool isSelected,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<ReminderCubit>().updateWorkingHoursMode(2);
      },
      child: Container(
        padding: const EdgeInsets.all((16)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withOpacity(0.15)
              : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular((12)),
          border: Border.all(
            color: isSelected
                ? AppColors.gold
                : AppColors.grey.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حدد الوقت بنفسك',
                      style: AppTextStyles.font16W600White(context).copyWith(
                        color: isSelected ? AppColors.gold : AppColors.white,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  const Icon(
                    SolarIconsBold.checkCircle,
                    color: AppColors.gold,
                    size: (20),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: (16)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectCustomTime(context, true, startTime),
                      child: Container(
                        padding: const EdgeInsets.all((12)),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular((12)),
                          border: Border.all(
                            color: AppColors.gold.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'من',
                              style: AppTextStyles.font12W500Grey(context),
                            ),
                            const SizedBox(height: (4)),
                            Text(
                              _formatTimeWithPeriod(startTime),
                              style: AppTextStyles.font16W600Gold(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: (12)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectCustomTime(context, false, endTime),
                      child: Container(
                        padding: const EdgeInsets.all((12)),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular((12)),
                          border: Border.all(
                            color: AppColors.gold.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'إلى',
                              style: AppTextStyles.font12W500Grey(context),
                            ),
                            const SizedBox(height: (4)),
                            Text(
                              _formatTimeWithPeriod(endTime),
                              style: AppTextStyles.font16W600Gold(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
