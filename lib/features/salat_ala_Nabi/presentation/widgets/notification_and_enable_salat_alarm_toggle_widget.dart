import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_state.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/toggle_title_and_switch_widget.dart';

class NotificationAndEnableSalatAlarmToggleWidget extends StatelessWidget {
  const NotificationAndEnableSalatAlarmToggleWidget({
    this.settings,
    super.key,
  });

  final ReminderSettingsModel? settings;

  @override
  Widget build(BuildContext context) {
    if (settings != null) {
      return _buildContent(context, settings!);
    }

    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is! ReminderLoaded) return const SizedBox.shrink();
        final cubit = context.read<ReminderCubit>();
        return _buildContent(
          context,
          state.settings,
          onEnabledChanged: cubit.toggleReminder,
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ReminderSettingsModel settings, {
    void Function({required bool value})? onEnabledChanged,
  }) {
    return Column(
      children: [
        ToggleTitleAndSwitchWidget(
          title: AppStrings.enableReminder,
          value: settings.isEnabled,
          onChanged: onEnabledChanged,
        ),
      ],
    );
  }
}
