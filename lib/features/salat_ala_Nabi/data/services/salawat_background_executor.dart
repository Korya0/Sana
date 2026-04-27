import 'dart:async';
import 'package:workmanager/workmanager.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/data/repos/reminder_repo.dart';

@pragma('vm:entry-point')
void salawatCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == AppSalawatConstants.taskName) {
      try {
        // 1. Initialize DI for background isolate
        await setupLocator();
        
        final settings = await sl<IReminderRepository>().getSettings();
        
        return await settings.when(
          success: (settingsModel) async {
            if (!settingsModel.isEnabled) return true;

            if (!settingsModel.isWithinWorkingHours(DateTime.now())) {
              return true;
            }

            // 2. Show Notification using DI service
            final notificationService = sl<INotificationService>();
            await notificationService.initialize();

            await notificationService.show(
              id: AppSalawatConstants.notificationBaseId + 100,
              title: AppStrings.salatAlaNabiTitle,
              body: AppStrings.salatAlaNabiNotificationBody,
              channelId: AppSalawatConstants.channelId,
              channelName: AppSalawatConstants.channelName,
              channelDescription: AppSalawatConstants.channelDescription,
              soundFileName: AppSalawatConstants.soundFileName,
            );

            return true;
          },
          failure: (_) => false,
        );
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
