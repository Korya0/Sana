import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_Nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/salawat_background_executor.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  /// تهيئة WorkManager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      salawatCallbackDispatcher,
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
