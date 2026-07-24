import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/salawat_reminder_service.dart';
import 'package:sana/features/salat_ala_nabi/domain/use_cases/update_working_hours_use_case.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubits/reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit(
    this._repo,
    this._reminderService,
  ) : super(const ReminderInitial());

  final ReminderRepository _repo;
  final SalawatReminderService _reminderService;
  ReminderSettingsEntity? _savedSettings;

  bool get hasUnsavedChanges {
    final s = state;
    if (s is ReminderLoaded) {
      return _savedSettings != null && s.settings != _savedSettings;
    }
    return false;
  }

  Future<void> init() async {
    await loadSettings();
  }

  Future<void> loadSettings() async {
    emit(const ReminderLoading());
    final result = await _repo.getSettings();

    switch (result) {
      case Success(data: final settings):
        _savedSettings = settings;
        emit(ReminderLoaded(settings));

        if (settings.isEnabled) {
          unawaited(_reminderService.scheduleReminders(settings));
        }
      case FailureResult(:final failure):
        unawaited(
          AppLogger.localError(
            'Error loading reminder settings: ${failure.message}',
          ),
        );
        // Fallback to default if load fails
        final defaultSettings = ReminderSettingsModel.defaultSettings();
        _savedSettings = defaultSettings;
        emit(ReminderLoaded(defaultSettings));
    }
  }

  void toggleReminder({required bool value}) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = ReminderSettingsEntity(
        isEnabled: value,
        intervalMinutes: s.settings.intervalMinutes,
        startHour: s.settings.startHour,
        startMinute: s.settings.startMinute,
        endHour: s.settings.endHour,
        endMinute: s.settings.endMinute,
        workingHoursMode: s.settings.workingHoursMode,
      );
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateInterval(int minutes) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = ReminderSettingsEntity(
        isEnabled: s.settings.isEnabled,
        intervalMinutes: minutes,
        startHour: s.settings.startHour,
        startMinute: s.settings.startMinute,
        endHour: s.settings.endHour,
        endMinute: s.settings.endMinute,
        workingHoursMode: s.settings.workingHoursMode,
      );
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateWorkingHoursMode(int mode) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = const UpdateWorkingHoursUseCase().call(
        settings: s.settings,
        mode: mode,
      );
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateStartTime(int hour, int minute) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = ReminderSettingsEntity(
        isEnabled: s.settings.isEnabled,
        intervalMinutes: s.settings.intervalMinutes,
        startHour: hour,
        startMinute: minute,
        endHour: s.settings.endHour,
        endMinute: s.settings.endMinute,
        workingHoursMode: s.settings.workingHoursMode,
      );
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateEndTime(int hour, int minute) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = ReminderSettingsEntity(
        isEnabled: s.settings.isEnabled,
        intervalMinutes: s.settings.intervalMinutes,
        startHour: s.settings.startHour,
        startMinute: s.settings.startMinute,
        endHour: hour,
        endMinute: minute,
        workingHoursMode: s.settings.workingHoursMode,
      );
      emit(ReminderLoaded(updatedSettings));
    }
  }

  Future<bool> saveChanges() async {
    final s = state;
    if (s is ReminderLoaded) {
      final settings = s.settings;
      final result = await _repo.saveSettings(settings);

      switch (result) {
        case Success():
          _savedSettings = settings;

          if (settings.isEnabled) {
            await _reminderService.scheduleReminders(settings);
            // Show confirmation notification once
            try {
              await _reminderService.showConfirmation();
            } on Object catch (e, stack) {
              unawaited(
                AppLogger.localError(
                  'Error showing confirmation reminder',
                  error: e,
                  stackTrace: stack,
                ),
              );
            }
          } else {
            await _reminderService.cancelReminders();
          }
          emit(ReminderLoaded(settings));
          return true;

        case FailureResult(:final failure):
          unawaited(
            AppLogger.localError(
              'Error saving reminder settings: ${failure.message}',
            ),
          );
          return false;
      }
    }
    return false;
  }

  void discardChanges() {
    if (_savedSettings != null) {
      emit(ReminderLoaded(_savedSettings!));
    }
  }
}
