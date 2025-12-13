// ignore_for_file: deprecated_member_use

import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import '../salawat_constants.dart';
import 'notification_service.dart';
import '../models/reminder_settings.dart';

// دالة التشغيل الخلفي (يجب أن تكون خارج الكلاس)
@pragma('vm:entry-point')
void callbackDispatcher() {
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
      } catch (e) {
        debugPrint('Error in background task: $e');
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

class WorkManagerService {
  /// تهيئة WorkManager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode, // وضع التصحيح أثناء التطوير فقط
    );
  }

  /// جدولة التذكير
  static Future<void> scheduleReminder(ReminderSettings settings) async {
    // إلغاء أي مهام سابقة أولاً
    await cancelReminder();

    if (!settings.isEnabled) return;

    await Workmanager().registerPeriodicTask(
      SalawatConstants.uniqueWorkName,
      SalawatConstants.taskName,
      frequency: Duration(minutes: settings.intervalMinutes),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      inputData: {
        'startHour': settings.startHour,
        'startMinute': settings.startMinute,
        'endHour': settings.endHour,
        'endMinute': settings.endMinute,
      },
    );
  }

  /// إلغاء التذكير
  static Future<void> cancelReminder() async {
    await Workmanager().cancelByUniqueName(SalawatConstants.uniqueWorkName);
  }
}
