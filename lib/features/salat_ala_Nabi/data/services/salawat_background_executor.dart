import 'package:sana/core/utils/app_logger.dart';

import 'package:sana/features/salat_ala_Nabi/data/salawat_constants.dart';

import 'package:sana/features/salat_ala_Nabi/data/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

// دالة التشغيل الخلفي (يجب أن تكون خارج كلاسات الواجهة لتجنب مشاكل الـ Analyzer)
@pragma('vm:entry-point')
void salawatCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == SalawatConstants.taskName) {
      try {
        // التحقق من ساعات العمل
        if (inputData != null) {
          final startHour = inputData['startHour'] as int?;
          final startMinute = inputData['startMinute'] as int?;
          final endHour = inputData['endHour'] as int?;
          final endMinute = inputData['endMinute'] as int?;

          if (startHour != null && endHour != null) {
            final now = DateTime.now();
            final currentMinutes = now.hour * 60 + now.minute;
            final startMinutes = startHour * 60 + (startMinute ?? 0);
            final endMinutes = endHour * 60 + (endMinute ?? 59);

            bool isWithinTime;
            if (startMinutes <= endMinutes) {
              isWithinTime =
                  currentMinutes >= startMinutes &&
                  currentMinutes <= endMinutes;
            } else {
              // حالة العمل الليلي (مثلاً من 10 مساءً إلى 6 صباحاً)
              isWithinTime =
                  currentMinutes >= startMinutes ||
                  currentMinutes <= endMinutes;
            }

            if (!isWithinTime) {
              return Future.value(true); // خارج وقت العمل، لا تفعل شيئاً
            }
          }
        }

        // تشغيل التنبيه
        final notificationService = NotificationService();
        await notificationService.initialize();
        await notificationService.showReminder();
      } on Exception catch (e) {
        AppLogger.error('Error in background task', error: e);
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}
