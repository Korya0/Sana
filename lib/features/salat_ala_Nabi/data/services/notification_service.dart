import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_Nabi/data/salawat_constants.dart';

class NotificationService {
  factory NotificationService() => _instance;
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// تهيئة الإشعارات وإنشاء القناة
  Future<void> initialize() async {
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initSettings = InitializationSettings(android: androidSettings);

      await _notifications.initialize(initSettings);

      // إنشاء القناة بصلاحيات عالية للصوت
      const androidChannel = AndroidNotificationChannel(
        SalawatConstants.channelId,
        SalawatConstants.channelName,
        description: SalawatConstants.channelDescription,
        importance: Importance.max, // أقصى أهمية للصوت
        sound: RawResourceAndroidNotificationSound(
          SalawatConstants.soundFileName,
        ),
        enableVibration: false, // لا نحتاج اهتزاز، الصوت يكفي
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(androidChannel);
    } catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Notification Initialize Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  /// عرض الإشعار وتشغيل الصوت
  Future<void> showReminder() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        SalawatConstants.channelId,
        SalawatConstants.channelName,
        channelDescription: SalawatConstants.channelDescription,
        importance: Importance.max,
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound(
          SalawatConstants.soundFileName,
        ),
        audioAttributesUsage:
            AudioAttributesUsage.alarm, // يعامل كمنبه لضمان التشغيل
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,

        // إخفاء التنبيه بعد انتهاء الصوت تقريباً (15 ثانية كافية جداً)
        timeoutAfter: 15000,

        // منع التكرار المزعج
        onlyAlertOnce: true,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _notifications.show(
        0, // ID ثابت لأننا لا نحتاج تراكم الإشعارات
        'الصلاة على النبي ﷺ',
        'اللهم صل وسلم وبارك على سيدنا محمد',
        notificationDetails,
      );
    } catch (e, stack) {
      unawaited(
        AppLogger.error('ShowReminder Error', error: e, stackTrace: stack),
      );
    }
  }

  /// إلغاء جميع الإشعارات
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
