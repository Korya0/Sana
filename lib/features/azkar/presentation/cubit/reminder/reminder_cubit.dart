import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/usecases/reminder_use_cases.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit({
    required ReminderUseCases reminderUseCases,
    required IAppPermissionsManager permissionsManager,
    required INotificationService notificationService,
  })  : _reminderUseCases = reminderUseCases,
        _permissionsManager = permissionsManager,
        _notificationService = notificationService,
        super(const ReminderInitial());

  final ReminderUseCases _reminderUseCases;
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
    final result = await _reminderUseCases.getReminders(azkarId);
    switch (result) {
      case Success(:final data):
        emit(ReminderLoaded(data));
      case FailureResult(:final failure):
        emit(ReminderError(failure.message));
    }
  }

  Future<void> createReminder(ReminderEntity reminder) async {
    final result = await _reminderUseCases.createReminder(
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
    final result = await _reminderUseCases.updateReminder(reminder);
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
    final result = await _reminderUseCases.deleteReminder(id);
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
    final result = await _reminderUseCases.toggleReminder(id, isEnabled: isEnabled);
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
