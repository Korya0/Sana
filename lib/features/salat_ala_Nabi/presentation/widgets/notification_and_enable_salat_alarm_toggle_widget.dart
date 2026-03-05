import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/toggle_title_and_switch_widget.dart';

class NotificationAndEnableSalatAlarmToggleWidget extends StatelessWidget {
  const NotificationAndEnableSalatAlarmToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReminderCubit>();
    final settings = context.watch<ReminderCubit>().state;

    if (settings == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Toggle Switch (تفعيل التذكير فقط)
        ToggleTitleAndSwitchWidget(
          title: AppStrings.enableReminder,
          value: settings.isEnabled,
          onChanged: cubit.toggleReminder,
        ),
      ],
    );
  }
}
