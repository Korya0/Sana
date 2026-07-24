abstract interface class NotificationService {
  Future<void> initialize();
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? soundFileName,
    String? payload,
  });
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
    String? matchDateTimeComponents, // 'time' or 'dayOfWeekAndTime'
  });
  Future<void> cancelAll();
  Future<void> cancel(int id);
  void setOnNotificationTap(void Function(String? payload) onTap);

  /// Returns whether the device allows scheduling exact alarms.
  /// On Android 12+, this checks the SCHEDULE_EXACT_ALARM permission.
  /// On other platforms, defaults to `true`.
  Future<bool> canScheduleExactAlarms();
}
