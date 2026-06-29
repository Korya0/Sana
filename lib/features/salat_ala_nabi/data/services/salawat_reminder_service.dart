import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';

abstract class ISalawatReminderService {
  Future<void> scheduleReminders(ReminderSettingsModel settings);
  Future<void> cancelReminders();
  Future<void> showConfirmation();
  Future<void> showSalawatNotification();
}

class SalawatReminderServiceImpl implements ISalawatReminderService {
  SalawatReminderServiceImpl(this._notificationService, this._workManagerService);

  final INotificationService _notificationService;
  final IWorkManagerService _workManagerService;

  @override
  Future<void> scheduleReminders(ReminderSettingsModel settings) async {
    await cancelReminders();
    if (!settings.isEnabled) return;

    await _workManagerService.registerPeriodicTask(
      uniqueName: AppSalawatConstants.uniqueWorkName,
      taskName: AppSalawatConstants.taskName,
      frequency: Duration(minutes: settings.intervalMinutes),
      inputData: settings.toJson(),
    );
  }

  @override
  Future<void> cancelReminders() async {
    await _workManagerService.cancelByUniqueName(AppSalawatConstants.uniqueWorkName);
    await _notificationService.cancel(AppSalawatConstants.cancelNotificationId);
    await _notificationService.cancel(AppSalawatConstants.notificationBaseId);
    await _notificationService.cancel(AppSalawatConstants.notificationBaseId + 100);
  }

  @override
  Future<void> showConfirmation() async {
    await _notificationService.initialize();
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
    await _notificationService.initialize();
    await _notificationService.show(
      id: AppSalawatConstants.notificationBaseId + 100,
      title: AppStrings.salatAlaNabiTitle,
      body: AppStrings.salatAlaNabiNotificationBody,
      channelId: AppSalawatConstants.channelId,
      channelName: AppSalawatConstants.channelName,
      channelDescription: AppSalawatConstants.channelDescription,
      soundFileName: AppSalawatConstants.soundFileName,
    );
  }
}
