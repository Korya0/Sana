class SalawatConstants {
  // Sound Configuration
  // الاسم بدون الامتداد .mp3 لأنه في مجلد raw
  static const String soundFileName = 'salat_ala_nabi_sound_1';

  // Notification Channel Configuration
  static const String channelId = 'salawat_reminder_channel_v1';
  static const String channelName = 'تذكير الصلاة على النبي';
  static const String channelDescription = 'تنبيهات صوتية للصلاة على النبي ﷺ';

  // WorkManager Configuration
  static const String taskName = 'salawat_reminder_task';
  static const String uniqueWorkName = 'salawat_periodic_work';
}

/// أوضاع ساعات العمل لتذكير الصلاة على النبي
class WorkingHoursMode {
  const WorkingHoursMode._();

  /// طوال اليوم (0 - 23:59)
  static const int allDay = 0;

  /// ساعات عمل افتراضية (9:00 - 17:00)
  static const int defaultHours = 1;

  /// وقت مخصص يحدده المستخدم
  static const int custom = 2;
}

