import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/notification/notification_keys.dart';

enum NotificationTemplate {
  morning(AppStrings.notificationMorningTitle, AppStrings.notificationMorningBody),
  evening(AppStrings.notificationEveningTitle, AppStrings.notificationEveningBody),
  night(AppStrings.notificationNightTitle, AppStrings.notificationNightBody),
  wakeUp(AppStrings.notificationWakeUpTitle, AppStrings.notificationWakeUpBody),
  general(AppStrings.notificationGeneralTitle, AppStrings.notificationGeneralBody);

  const NotificationTemplate(this.title, this.body);

  final String title;
  final String body;

  static NotificationTemplate fromAzkarId(String azkarId) {
    switch (azkarId) {
      case NotificationKeys.morningAzkarId:
        return NotificationTemplate.morning;
      case NotificationKeys.eveningAzkarId:
        return NotificationTemplate.evening;
      case NotificationKeys.sleepAzkarId:
        return NotificationTemplate.night;
      case NotificationKeys.wakeUpAzkarId:
        return NotificationTemplate.wakeUp;
      default:
        return NotificationTemplate.general;
    }
  }
}
