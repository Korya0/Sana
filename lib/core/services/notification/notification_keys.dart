abstract class NotificationKeys {
  // Payload JSON keys
  static const String id = 'id';
  static const String type = 'type';
  static const String data = 'data';

  // Custom payload data keys
  static const String azkarId = 'azkarId';
  static const String prayerName = 'prayerName';

  // Notification types
  static const String typeAzkar = 'azkar_reminder';
  static const String typePrayer = 'prayer_reminder';
  static const String typeSalawat = 'salawat_reminder';

  // Repeat types (DateTimeComponents match names)
  static const String matchTime = 'time';
  static const String matchDayOfWeekAndTime = 'dayOfWeekAndTime';
}
