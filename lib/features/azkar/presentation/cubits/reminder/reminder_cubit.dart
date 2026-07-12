import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/usecases/create_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/delete_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/get_reminders_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/toggle_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/update_reminder_use_case.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/presentation/cubits/reminder/reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit({
    required GetRemindersUseCase getReminders,
    required CreateReminderUseCase createReminder,
    required UpdateReminderUseCase updateReminder,
    required DeleteReminderUseCase deleteReminder,
    required ToggleReminderUseCase toggleReminder,
    required IAppPermissionsManager permissionsManager,
    required INotificationService notificationService,
  })  : _getReminders = getReminders,
        _createReminder = createReminder,
        _updateReminder = updateReminder,
        _deleteReminder = deleteReminder,
        _toggleReminder = toggleReminder,
        _permissionsManager = permissionsManager,
        _notificationService = notificationService,
        super(const ReminderInitial());

  final GetRemindersUseCase _getReminders;
  final CreateReminderUseCase _createReminder;
  final UpdateReminderUseCase _updateReminder;
  final DeleteReminderUseCase _deleteReminder;
  final ToggleReminderUseCase _toggleReminder;
  final IAppPermissionsManager _permissionsManager;
  final INotificationService _notificationService;

  Future<bool> requestPermissions() async {
    final notificationGranted =
        await _permissionsManager.requestNotificationPermission();
    if (!notificationGranted) return false;

    return _notificationService.canScheduleExactAlarms();
  }

  Future<void> openSettings() async {
    await _permissionsManager.openSettings();
  }

  Future<void> loadReminders(String azkarId) async {
    emit(const ReminderLoading());
    final result = await _getReminders(azkarId);
    switch (result) {
      case Success(:final data):
        emit(ReminderLoaded(data));
      case FailureResult(:final failure):
        emit(ReminderError(failure.message));
    }
  }

  Future<void> createReminder(ReminderEntity reminder) async {
    final result = await _createReminder(
      _toParams(reminder),
    );
    switch (result) {
      case FailureResult(:final failure):
        emit(ReminderError(failure.message));
        return;
      case Success():
        break;
    }
    await loadReminders(reminder.azkarId);
  }

  Future<void> updateReminder(ReminderEntity reminder) async {
    final result = await _updateReminder(reminder);
    switch (result) {
      case FailureResult(:final failure):
        emit(ReminderError(failure.message));
        return;
      case Success():
        break;
    }
    await loadReminders(reminder.azkarId);
  }

  Future<void> deleteReminder(String id, String azkarId) async {
    final result = await _deleteReminder(id);
    switch (result) {
      case FailureResult(:final failure):
        emit(ReminderError(failure.message));
        return;
      case Success():
        break;
    }
    await loadReminders(azkarId);
  }

  Future<void> toggleReminder(
    String id,
    String azkarId, {
    required bool isEnabled,
  }) async {
    final result = await _toggleReminder(id, isEnabled: isEnabled);
    switch (result) {
      case FailureResult(:final failure):
        emit(ReminderError(failure.message));
        return;
      case Success():
        break;
    }
    await loadReminders(azkarId);
  }

  CreateReminderParams _toParams(ReminderEntity r) => CreateReminderParams(
        azkarId: r.azkarId,
        time: r.time,
        repeatType: r.repeatType,
        days: r.days,
        isEnabled: r.isEnabled,
        timezone: r.timezone,
        template: r.template,
      );
}
