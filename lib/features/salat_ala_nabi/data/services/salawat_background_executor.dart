import 'dart:async';

import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/data/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_reminder_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void salawatCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == AppSalawatConstants.taskName) {
      try {
        // 1. Initialize DI for background isolate
        await setupLocator();

        final settings = await sl<IReminderRepository>().getSettings();

        switch (settings) {
          case Success(data: final settingsModel):
            if (!settingsModel.isEnabled) return true;

            if (!settingsModel.isWithinWorkingHours(DateTime.now())) {
              return true;
            }

            // 2. Show Notification using Feature Service
            await sl<ISalawatReminderService>().showSalawatNotification();

            return true;
          case FailureResult():
            return false;
        }
      } on Exception catch (e, stack) {
        unawaited(
          AppLogger.error(
            'Error in background salawat task',
            error: e,
            stackTrace: stack,
          ),
        );
        return false;
      }
    }
    return true;
  });
}
