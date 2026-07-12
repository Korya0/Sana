import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/notification/notification_keys.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceImpl implements INotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  void Function(String? payload)? _onTap;
  String? _pendingPayload;

  @override
  void setOnNotificationTap(void Function(String? payload) onTap) {
    _onTap = onTap;
    if (_pendingPayload != null) {
      onTap(_pendingPayload);
      _pendingPayload = null;
    }
  }

  @override
  Future<bool> canScheduleExactAlarms() async {
    try {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        final canSchedule = await androidPlugin.canScheduleExactNotifications();
        return canSchedule ?? false;
      }
      return true; // non-Android: assume exact alarms are available
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'canScheduleExactAlarms Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return true; // fallback optimistic
    }
  }

  @override
  Future<void> initialize() async {
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const darwinSettings = DarwinInitializationSettings();

      tz_data.initializeTimeZones();
      try {
        final timeZoneName = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      } on Exception catch (e, stackTrace) {
        unawaited(
          AppLogger.warn(
            'Failed to get local timezone, falling back to Africa/Cairo',
            error: e,
            stackTrace: stackTrace,
          ),
        );
        tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      }

      await _notifications.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: darwinSettings,
          macOS: darwinSettings,
        ),
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (_onTap != null) {
            _onTap?.call(payload);
          } else {
            _pendingPayload = payload;
          }
        },
      );

      final launchDetails = await _notifications
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        final payload = launchDetails?.notificationResponse?.payload;
        if (payload != null) {
          if (_onTap != null) {
            _onTap?.call(payload);
          } else {
            _pendingPayload = payload;
          }
        }
      }
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
    String? payload,
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
        payload: payload,
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'ShowNotification Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  @override
  Future<void> zonedSchedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? soundFileName,
    String? payload,
    String? matchDateTimeComponents,
  }) async {
    try {
      final notificationDetails = _getNotificationDetails(
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
        soundFileName: soundFileName,
      );

      final tzDateTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

      DateTimeComponents? matchComponents;
      if (matchDateTimeComponents == NotificationKeys.matchTime) {
        matchComponents = DateTimeComponents.time;
      } else if (matchDateTimeComponents ==
          NotificationKeys.matchDayOfWeekAndTime) {
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
      }

      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDateTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
        matchDateTimeComponents: matchComponents,
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'ZonedSchedule Error',
          error: e,
          stackTrace: stack,
        ),
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
