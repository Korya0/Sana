import 'dart:async';

import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/notification/notification_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_background_task_handler.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/salawat_reminder_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void salawatCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return _executeSalawatTask(task, DateTime.now());
  });
}

Future<bool> _executeSalawatTask(String task, DateTime currentTime) async {
  try {
    // Initialize DI for background isolate
    await setupLocator();

    final handler = SalawatBackgroundTaskHandler(
      reminderRepository: sl<ReminderRepository>(),
      notificationService: sl<NotificationService>(),
      salawatReminderService: sl<SalawatReminderService>(),
    );

    return handler.execute(task, currentTime);
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
