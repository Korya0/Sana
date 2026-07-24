import 'package:sana/features/azkar/data/models/reminder_model.dart';

abstract interface class ReminderLocalDataSource {
  Future<List<ReminderModel>> getReminders(String azkarId);
  Future<List<ReminderModel>> getAllReminders();
  Future<void> saveReminder(ReminderModel reminder);
  Future<void> deleteReminder(String id);
}
