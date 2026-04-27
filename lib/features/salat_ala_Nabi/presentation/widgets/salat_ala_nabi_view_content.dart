import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v18,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: AppSpacing.v16),
          NotificationAndEnableSalatAlarmToggleWidget(
            settings: isSkeleton ? settings : null,
          ),
          const SizedBox(height: AppSpacing.v18 * 2),
          IntervalCounterWidget(
            intervalMinutes: isSkeleton ? settings.intervalMinutes : null,
          ),
          const SizedBox(height: AppSpacing.v18 * 2),
          WorkingHoursWidget(
            settings: isSkeleton ? settings : null,
          ),
          const SizedBox(height: AppSpacing.v18 * 2),
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
