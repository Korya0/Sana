import 'dart:async';

import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/i_reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/i_salawat_reminder_service.dart';
import 'package:sana/features/salat_ala_nabi/domain/use_cases/check_working_hours_use_case.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void salawatCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return _executeSalawatTask(task, DateTime.now());
  });
}

Future<bool> _executeSalawatTask(String task, DateTime currentTime) async {
  if (task == AppSalawatConstants.taskName) {
    try {
      // 1. Initialize DI for background isolate
      await setupLocator();
      await sl<INotificationService>().initialize();

      final settings = await sl<IReminderRepository>().getSettings();

      switch (settings) {
        case Success(data: final settingsEntity):
          if (!settingsEntity.isEnabled) return true;

          final isWithinHours = const CheckWorkingHoursUseCase().call(
            settings: settingsEntity,
            time: currentTime,
          );

          if (!isWithinHours) {
            return true;
          }

          // 2. Show Notification using Feature Service
          await sl<ISalawatReminderService>().showSalawatNotification();

          return true;
        case FailureResult():
          return false;
      }
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Error in background salawat task',
          error: e,
          stackTrace: stack,
        ),
      );
      return false;
    }
  }
  return true;
}
