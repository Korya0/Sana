import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/usecases/create_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/delete_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/get_reminders_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/toggle_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/update_reminder_use_case.dart';

/// Facade that bundles all reminder-related use cases into a single dependency.
/// This reduces ReminderCubit's constructor dependencies from 5 to 1.
class ReminderUseCases {
  const ReminderUseCases({
    required GetRemindersUseCase getReminders,
    required CreateReminderUseCase createReminder,
    required UpdateReminderUseCase updateReminder,
    required DeleteReminderUseCase deleteReminder,
    required ToggleReminderUseCase toggleReminder,
  })  : _getReminders = getReminders,
        _createReminder = createReminder,
        _updateReminder = updateReminder,
        _deleteReminder = deleteReminder,
        _toggleReminder = toggleReminder;

  final GetRemindersUseCase _getReminders;
  final CreateReminderUseCase _createReminder;
  final UpdateReminderUseCase _updateReminder;
  final DeleteReminderUseCase _deleteReminder;
  final ToggleReminderUseCase _toggleReminder;

  Future<Result<List<ReminderEntity>>> getReminders(String azkarId) =>
      _getReminders(azkarId);

  Future<Result<void>> createReminder(CreateReminderParams params) =>
      _createReminder(params);

  Future<Result<void>> updateReminder(ReminderEntity reminder) =>
      _updateReminder(reminder);

  Future<Result<void>> deleteReminder(String id) =>
      _deleteReminder(id);

  Future<Result<void>> toggleReminder(String id, {required bool isEnabled}) =>
      _toggleReminder(id, isEnabled: isEnabled);
}
