import 'package:hive_flutter/hive_flutter.dart';

import 'package:sana/features/azkar/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';

class ReminderLocalDataSourceImpl implements ReminderLocalDataSource {
  const ReminderLocalDataSourceImpl(this._box);

  final Box<ReminderModel> _box;

  static const String _boxName = 'reminders_box';

  static String get boxName => _boxName;

  @override
  Future<List<ReminderModel>> getReminders(String azkarId) async {
    try {
      if (azkarId.isEmpty) {
        return _box.values.toList();
      }
      final values = _box.values.where((r) => r.azkarId == azkarId).toList();
      return values;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ReminderModel>> getAllReminders() async {
    try {
      return _box.values.toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveReminder(ReminderModel reminder) async {
    try {
      await _box.put(reminder.id, reminder);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    try {
      await _box.delete(id);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
