import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/utils/utils.dart';

class NotificationServiceImpl implements INotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const darwinSettings = DarwinInitializationSettings();

      await _notifications.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: darwinSettings,
          macOS: darwinSettings,
        ),
        onDidReceiveNotificationResponse: (_) {},
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Notification Initialize Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? soundFileName,
  }) async {
    try {
      final notificationDetails = _getNotificationDetails(
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
        soundFileName: soundFileName,
      );

      await _notifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase('ShowNotification Error', error: e, stackTrace: stack),
      );
    }
  }

  NotificationDetails _getNotificationDetails({
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? soundFileName,
  }) {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? AppStrings.notificationDefaultChannelId,
      channelName ?? AppStrings.notificationDefaultChannelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      sound: soundFileName != null
          ? RawResourceAndroidNotificationSound(soundFileName)
          : null,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.reminder,
      onlyAlertOnce: true,
    );

    const darwinDetails = DarwinNotificationDetails();

    return NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
  }

  @override
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  @override
  Future<void> cancel(int id) async {
    await _notifications.cancel(id: id);
  }
}
