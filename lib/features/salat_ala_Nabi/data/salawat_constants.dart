import 'package:sana/core/constants/app_strings.dart';

class AppSalawatConstants {
  static const String soundFileName = 'salat_ala_nabi_sound_1';

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
}

class WorkingHoursMode {
  const WorkingHoursMode._();

  static const int allDay = 0;
  static const int defaultHours = 1;
  static const int custom = 2;
}
