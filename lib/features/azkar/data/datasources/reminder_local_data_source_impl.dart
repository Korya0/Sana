import 'package:hive_flutter/hive_flutter.dart';

import 'package:sana/features/azkar/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';

class ReminderLocalDataSourceImpl implements IReminderLocalDataSource {
  const ReminderLocalDataSourceImpl(this._box);

  final Box<ReminderModel> _box;

  static const String _boxName = 'reminders_box';

  static String get boxName => _boxName;

  @override
  Future<List<ReminderModel>> getReminders(String azkarId) async {
    if (azkarId.isEmpty) {
      return _box.values.toList();
    }
    final values = _box.values.where((r) => r.azkarId == azkarId).toList();
    return values;
  }

  @override
  Future<List<ReminderModel>> getAllReminders() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveReminder(ReminderModel reminder) async {
    await _box.put(reminder.id, reminder);
  }

  @override
  Future<void> deleteReminder(String id) async {
    await _box.delete(id);
  }
}
