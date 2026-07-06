import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/i_salawat_reminder_service.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';

class SalawatReminderServiceImpl implements ISalawatReminderService {
  SalawatReminderServiceImpl(
    this._notificationService,
    this._workManagerService,
  );

  final INotificationService _notificationService;
  final IWorkManagerService _workManagerService;

  @override
  Future<void> scheduleReminders(ReminderSettingsEntity settings) async {
    await cancelReminders();
    if (!settings.isEnabled) return;

    final settingsModel = settings is ReminderSettingsModel
        ? settings
        : ReminderSettingsModel.fromEntity(settings);

    await _workManagerService.registerPeriodicTask(
      uniqueName: AppSalawatConstants.uniqueWorkName,
      taskName: AppSalawatConstants.taskName,
      frequency: Duration(minutes: settings.intervalMinutes),
      inputData: settingsModel.toJson(),
    );
  }

  @override
  Future<void> cancelReminders() async {
    await _workManagerService.cancelByUniqueName(
      AppSalawatConstants.uniqueWorkName,
    );
    await _notificationService.cancel(AppSalawatConstants.cancelNotificationId);
    await _notificationService.cancel(AppSalawatConstants.notificationBaseId);
    await _notificationService.cancel(
      AppSalawatConstants.notificationSalawatId,
    );
  }

  @override
  Future<void> showConfirmation() async {
    await _notificationService.show(
      id: AppSalawatConstants.notificationBaseId,
      title: AppStrings.salatAlaNabiTitle,
      body: AppStrings.salatAlaNabiNotificationBody,
      channelId: AppSalawatConstants.channelId,
      channelName: AppSalawatConstants.channelName,
      channelDescription: AppSalawatConstants.channelDescription,
      soundFileName: AppSalawatConstants.soundFileName,
    );
  }

  @override
  Future<void> showSalawatNotification() async {
    await _notificationService.show(
      id: AppSalawatConstants.notificationSalawatId,
      title: AppStrings.salatAlaNabiTitle,
      body: AppStrings.salatAlaNabiNotificationBody,
      channelId: AppSalawatConstants.channelId,
      channelName: AppSalawatConstants.channelName,
      channelDescription: AppSalawatConstants.channelDescription,
      soundFileName: AppSalawatConstants.soundFileName,
    );
  }
}
