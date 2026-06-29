import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/toggle_title_and_switch_widget.dart';

class NotificationAndEnableSalatAlarmToggleWidget extends StatelessWidget {
  const NotificationAndEnableSalatAlarmToggleWidget({
    required this.settings,
    this.onEnabledChanged,
    super.key,
  });

  final ReminderSettingsModel settings;
  final void Function({required bool value})? onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return ToggleTitleAndSwitchWidget(
      title: AppStrings.enableReminder,
      value: settings.isEnabled,
      onChanged: onEnabledChanged,
    );
  }
}
