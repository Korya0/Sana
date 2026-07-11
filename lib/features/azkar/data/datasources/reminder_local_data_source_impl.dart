import 'package:hive_flutter/hive_flutter.dart';
import 'package:sana/core/utils/utils.dart';
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
      final values = _box.values.where((r) => r.azkarId == azkarId).toList();
      return values;
    } on Exception catch (e, stack) {
      await AppLogger.error('ReminderLocalDataSourceImpl.getReminders', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> saveReminder(ReminderModel reminder) async {
    try {
      await _box.put(reminder.id, reminder);
    } on Exception catch (e, stack) {
      await AppLogger.error('ReminderLocalDataSourceImpl.saveReminder', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    try {
      await _box.delete(id);
    } on Exception catch (e, stack) {
      await AppLogger.error('ReminderLocalDataSourceImpl.deleteReminder', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
