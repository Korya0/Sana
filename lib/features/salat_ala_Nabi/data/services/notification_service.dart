import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../salawat_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// تهيئة الإشعارات وإنشاء القناة
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);

    // إنشاء القناة بصلاحيات عالية للصوت
    final androidChannel = AndroidNotificationChannel(
      SalawatConstants.channelId,
      SalawatConstants.channelName,
      description: SalawatConstants.channelDescription,
      importance: Importance.max, // أقصى أهمية للصوت
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        SalawatConstants.soundFileName,
      ),
      enableVibration: false, // لا نحتاج اهتزاز، الصوت يكفي
      enableLights: false,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// عرض الإشعار وتشغيل الصوت
  Future<void> showReminder() async {
    final androidDetails = AndroidNotificationDetails(
      SalawatConstants.channelId,
      SalawatConstants.channelName,
      channelDescription: SalawatConstants.channelDescription,
      importance: Importance.max,
      priority: Priority.max,

      // إعدادات الصوت الحاسمة
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        SalawatConstants.soundFileName,
      ),
      audioAttributesUsage:
          AudioAttributesUsage.alarm, // يعامل كمنبه لضمان التشغيل
      // سلوك الإشعار
      autoCancel: true, // يختفي عند الضغط
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.alarm,

      // إخفاء التنبيه بعد انتهاء الصوت تقريباً (15 ثانية كافية جداً)
      timeoutAfter: 15000,

      // منع التكرار المزعج
      onlyAlertOnce: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0, // ID ثابت لأننا لا نحتاج تراكم الإشعارات
      'الصلاة على النبي ﷺ',
      'اللهم صل وسلم وبارك على سيدنا محمد',
      notificationDetails,
    );
  }

  /// إلغاء جميع الإشعارات
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
