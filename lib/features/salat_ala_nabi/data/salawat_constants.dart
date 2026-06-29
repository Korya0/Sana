import 'package:sana/core/constants/constants.dart';

class AppSalawatConstants {
  static final String soundFileName =
      AppAssets.salatAlaNabiSound1.split('/').last.split('.').first;

  static const String channelId = 'salawat_reminder_channel_v1';
  static const String channelName = AppStrings.salatAlaNabiTitle;
  static const String channelDescription =
      AppStrings.salatAlaNabiChannelDescription;

  static const String taskName = 'salawat_reminder_task';
  static const String uniqueWorkName = 'salawat_periodic_work';

  static const String keyIsEnabled = 'isEnabled';
  static const String keyIntervalMinutes = 'intervalMinutes';
  static const String keyStartHour = 'startHour';
  static const String keyStartMinute = 'startMinute';
  static const String keyEndHour = 'endHour';
  static const String keyEndMinute = 'endMinute';
  static const String keyWorkingHoursMode = 'workingHoursMode';

  static const int notificationQueueSize = 80;
  static const int notificationBaseId = 1000;
  static const int cancelNotificationId = 0;

  static const int defaultStartHour = 9;
  static const int defaultEndHour = 17;
}

class WorkingHoursMode {
  const WorkingHoursMode._();

  static const int allDay = 0;
  static const int defaultHours = 1;
  static const int custom = 2;
}
