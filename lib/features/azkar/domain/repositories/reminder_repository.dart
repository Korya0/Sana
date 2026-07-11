import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';

abstract interface class ReminderRepository {
  Future<Result<List<ReminderEntity>>> getReminders(String azkarId);
  Future<Result<List<ReminderEntity>>> getAllReminders();
  Future<Result<void>> createReminder(ReminderEntity reminder);
  Future<Result<void>> updateReminder(ReminderEntity reminder);
  Future<Result<void>> deleteReminder(String id);
  Future<Result<void>> toggleReminder(String id, {required bool isEnabled});

  /// Reschedules all active (enabled) reminders.
  /// Used on app startup to restore notification schedules.
  Future<void> rescheduleAllActiveReminders();
}
