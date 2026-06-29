import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/interval_counter_widget.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/notification_and_enable_salat_alarm_toggle_widget.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/working_hours_widget.dart';

class SalatAlaNabiViewContent extends StatelessWidget {
  const SalatAlaNabiViewContent({
    required this.settings,
    this.hasUnsavedChanges = false,
    this.onSave,
    this.isSkeleton = false,
    super.key,
  });

  final ReminderSettingsModel settings;
  final bool hasUnsavedChanges;
  final VoidCallback? onSave;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    final cubit = isSkeleton ? null : context.read<ReminderCubit>();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v18,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: AppSpacing.v16),
          NotificationAndEnableSalatAlarmToggleWidget(
            settings: settings,
            onEnabledChanged: cubit?.toggleReminder,
          ),
          const SizedBox(height: AppSpacing.v32),
          IntervalCounterWidget(
            intervalMinutes: settings.intervalMinutes,
            onIntervalChanged: cubit?.updateInterval,
          ),
          const SizedBox(height: AppSpacing.v32),
          WorkingHoursWidget(
            settings: settings,
            onModeChanged: cubit?.updateWorkingHoursMode,
            onStartTimeChanged: cubit?.updateStartTime,
            onEndTimeChanged: cubit?.updateEndTime,
          ),
          const SizedBox(height: AppSpacing.v32),
          if (hasUnsavedChanges || isSkeleton)
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.v32,
              ),
              child: AppPrimaryButton(
                text: AppStrings.saveChanges,
                onPressed: onSave ?? () {},
              ),
            ),
        ]),
      ),
    );
  }
}
