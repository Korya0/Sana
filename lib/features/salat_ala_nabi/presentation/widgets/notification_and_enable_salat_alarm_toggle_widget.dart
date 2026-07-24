import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/toggle_title_and_switch_widget.dart';

class NotificationAndEnableSalatAlarmToggleWidget extends StatelessWidget {
  const NotificationAndEnableSalatAlarmToggleWidget({
    required this.settings,
    this.onEnabledChanged,
    super.key,
  });

  final ReminderSettingsEntity settings;
  final void Function({required bool value})? onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return ToggleTitleAndSwitchWidget(
      title: AppStrings.enableReminder,
      value: settings.isEnabled,
      onChanged: onEnabledChanged == null
          ? null
          : ({required value}) async {
              if (value) {
                if (kIsWeb) return;
                // Show rationale dialog before requesting notification permission
                if (!context.mounted) return;
                final userConsented = await showPermissionRationaleDialog(
                  context: context,
                  title: AppStrings.notificationPermissionTitle,
                  message: AppStrings.notificationPermissionMessage,
                );
                if (!userConsented) return;

                if (!context.mounted) return;
                final hasPermission = await sl<AppPermissionsManager>()
                    .requestNotificationPermission();
                if (!hasPermission) {
                  if (context.mounted) {
                    AppToast.show(
                      context,
                      AppStrings.reminderPermissionDeniedMessage,
                      type: AppToastType.warning,
                    );
                  }
                  return;
                }
              }
              onEnabledChanged!(value: value);
            },
    );
  }
}
