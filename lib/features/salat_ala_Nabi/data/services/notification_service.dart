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
      const darwinSettings = DarwinInitializationSettings();
      // v21 Breaking Change: initialize() now uses named parameter `settings:`
      await _notifications.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: darwinSettings,
          macOS: darwinSettings,
        ),
        onDidReceiveNotificationResponse: (_) {},
      );

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
    } on Exception catch (e, stack) {
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
        audioAttributesUsage: AudioAttributesUsage.alarm,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,
        timeoutAfter: 15000,
        onlyAlertOnce: true,
      );

      const darwinDetails = DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
        categoryIdentifier: SalawatConstants.channelId,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      // v21 Breaking Change: show() now uses named parameters for all args
      await _notifications.show(
        id: 0,
        title: 'الصلاة على النبي ﷺ',
        body: 'اللهم صل وسلم وبارك على سيدنا محمد',
        notificationDetails: notificationDetails,
      );
    } on Exception catch (e, stack) {
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
