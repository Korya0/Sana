import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/cubit/reminder_cubit.dart';
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
          title: 'تفعيل التذكير',
          value: settings.isEnabled,
          onChanged: (value) {
            // [Web Support] عرض رسالة تنبيه عند محاولة تفعيل الميزة على الويب
            if (kIsWeb) {
              AppToast.show(
                context,
                'عذراً، ميزة التذكير بالصلاة على النبي غير مدعومة على الويب حالياً',
              );
              return;
            }
            cubit.toggleReminder(value);
          },
        ),
      ],
    );
  }
}
