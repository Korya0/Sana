import 'package:sana/core/services/notification/models/notification_payload.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';
import 'package:sana/core/services/notification/notification_keys.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

class ReminderSchedulerHelper {
  const ReminderSchedulerHelper._();

  /// Schedules one notification per effective day.
  static Future<void> scheduleAll(
    ReminderEntity reminder,
    NotificationScheduler scheduler,
  ) async {
    final hour = reminder.hour;
    final minute = reminder.minute;

    final effectiveDays = reminder.repeatType == RepeatType.daily
        ? List.generate(7, (i) => i + 1)
        : reminder.repeatType == RepeatType.once
            ? <int>[]
            : reminder.days;

    final payload = NotificationPayload(
      id: reminder.id,
      type: NotificationKeys.typeAzkar,
      data: {NotificationKeys.azkarId: reminder.azkarId},
    );

    if (effectiveDays.isEmpty) {
      // Once: schedule for today/tomorrow at given time
      final now = DateTime.now();
      var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await scheduler.schedule(
        NotificationRequest(
          id: reminder.id.hashCode,
          title: reminder.template.title,
          body: reminder.template.body,
          scheduledDateTime: scheduled,
          payload: payload,
        ),
      );
    } else {
      // Daily or custom days: one notification per weekday
      for (final day in effectiveDays) {
        final now = DateTime.now();
        var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
        // Advance to the next matching weekday
        while (scheduled.weekday != day || scheduled.isBefore(now)) {
          scheduled = scheduled.add(const Duration(days: 1));
        }
        await scheduler.schedule(
          NotificationRequest(
            id: _dayNotificationId(reminder.id, day),
            title: reminder.template.title,
            body: reminder.template.body,
            scheduledDateTime: scheduled,
            payload: payload,
            repeats: true,
            weekdays: [day],
          ),
        );
      }
    }
  }

  static Future<void> cancelAll(
    String reminderId,
    NotificationScheduler scheduler,
  ) async {
    // Cancel once notification
    await scheduler.cancel(reminderId.hashCode);
    // Cancel per-day notifications (days 1–7)
    for (var day = 1; day <= 7; day++) {
      await scheduler.cancel(_dayNotificationId(reminderId, day));
    }
  }

  static int _dayNotificationId(String reminderId, int day) =>
      '${reminderId}_$day'.hashCode;
}
