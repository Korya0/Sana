import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/salat_ala_Nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_state.dart';
import 'package:solar_icons/solar_icons.dart';

/// Widget for selecting working hours mode
class WorkingHoursWidget extends StatelessWidget {
  const WorkingHoursWidget({super.key});

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
              hourMinuteTextColor: AppColors.white,
              dayPeriodTextColor: AppColors.white,
              dialHandColor: AppColors.primary,
              dialBackgroundColor: AppColors.scaffoldBackground,
              hourMinuteColor: AppColors.scaffoldBackground,
              dayPeriodColor: AppColors.scaffoldBackground,
              dayPeriodTextStyle: AppTextStyles.font14W600White(context),
              helpTextStyle: AppTextStyles.font16W600primary(context),
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
    final period = time.period == DayPeriod.am ? AppStrings.am : AppStrings.pm;
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is! ReminderLoaded) return const SizedBox.shrink();

        final settings = state.settings;
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
              style: AppTextStyles.font16W600White(context),
            ),
            const SizedBox(height: AppSpacing.v18),

            // Option 1: طوال اليوم
            _buildWorkingHourOption(
              context: context,
              index: WorkingHoursMode.allDay,
              title: AppStrings.allDay,
              subtitle: AppStrings.twentyFourHours,
              isSelected: selectedMode == WorkingHoursMode.allDay,
            ),
            const SizedBox(height: AppSpacing.v18 - 8),

            // Option 2: 10 ص - 10 م
            _buildWorkingHourOption(
              context: context,
              index: WorkingHoursMode.defaultHours,
              title: AppStrings.from10amTo10pm,
              subtitle: AppStrings.tenAmTenPm,
              isSelected: selectedMode == WorkingHoursMode.defaultHours,
            ),
            const SizedBox(height: AppSpacing.v18 - 8),

            // Option 3: مخصص
            _buildCustomWorkingHourOption(
              context: context,
              isSelected: selectedMode == WorkingHoursMode.custom,
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
        padding: const EdgeInsets.all(AppSpacing.v16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey.withValues(alpha: 0.3),
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
                    color: isSelected ? AppColors.textPrimary : AppColors.textWhite,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                SolarIconsBold.checkCircle,
                color: AppColors.iconPrimary,
                size: 20,
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
        context.read<ReminderCubit>().updateWorkingHoursMode(
          WorkingHoursMode.custom,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.v16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey.withValues(alpha: 0.3),
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
                      AppStrings.selectCustomTime,
                      style: AppTextStyles.font16W600White(context).copyWith(
                        color: isSelected ? AppColors.primary : AppColors.white,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  const Icon(
                    SolarIconsBold.checkCircle,
                    color: AppColors.iconPrimary,
                    size: 20,
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectCustomTime(context, true, startTime),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.v12),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusM,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.from,
                              style: AppTextStyles.font12W500Grey(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimeWithPeriod(startTime),
                              style: AppTextStyles.font16W600primary(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectCustomTime(context, false, endTime),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.v12),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusM,
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.to,
                              style: AppTextStyles.font12W500Grey(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimeWithPeriod(endTime),
                              style: AppTextStyles.font16W600primary(context),
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
