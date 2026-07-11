abstract interface class INotificationService {
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
}
