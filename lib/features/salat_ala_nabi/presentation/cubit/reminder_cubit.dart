import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/data/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_reminder_service.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit(
    this._repo,
    this._reminderService,
    this._permissionsManager,
  ) : super(const ReminderInitial()) {
    unawaited(loadSettings());
  }
  final IReminderRepository _repo;
  final ISalawatReminderService _reminderService;
  final IAppPermissionsManager _permissionsManager;
  ReminderSettingsModel? _savedSettings;

  bool get hasUnsavedChanges {
    final s = state;
    if (s is ReminderLoaded) {
      return _savedSettings != null && s.settings != _savedSettings;
    }
    return false;
  }

  Future<void> loadSettings() async {
    emit(const ReminderLoading());
    final result = await _repo.getSettings();

    switch (result) {
      case Success(data: final settings):
        _savedSettings = settings;
        emit(ReminderLoaded(settings));

        if (!kIsWeb && settings.isEnabled) {
          unawaited(_reminderService.scheduleReminders(settings));
        }
      case ApiFailure(:final failure):
        unawaited(
          AppLogger.error(
            'Error loading reminder settings: ${failure.message}',
          ),
        );
        // Fallback to default if load fails
        final defaultSettings = ReminderSettingsModel.defaultSettings();
        _savedSettings = defaultSettings;
        emit(ReminderLoaded(defaultSettings));
    }
  }

  Future<void> toggleReminder({required bool value}) async {
    final s = state;
    if (s is ReminderLoaded) {
      if (value) {
        if (kIsWeb) return;

        final hasPermission =
            await _permissionsManager.requestNotificationPermission();
        if (!hasPermission) return;
      }

      final updatedSettings = s.settings.copyWith(isEnabled: value);
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateInterval(int minutes) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = s.settings.copyWith(intervalMinutes: minutes);
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateWorkingHoursMode(int mode) {
    final s = state;
    if (s is ReminderLoaded) {
      var updatedSettings = s.settings.copyWith(workingHoursMode: mode);
      switch (mode) {
        case WorkingHoursMode.allDay:
          updatedSettings = updatedSettings.copyWith(
            startHour: 0,
            startMinute: 0,
            endHour: 23,
            endMinute: 59,
          );
        case WorkingHoursMode.defaultHours:
          updatedSettings = updatedSettings.copyWith(
            startHour: AppSalawatConstants.defaultStartHour,
            startMinute: 0,
            endHour: AppSalawatConstants.defaultEndHour,
            endMinute: 0,
          );
      }
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateStartTime(int hour, int minute) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = s.settings.copyWith(
        startHour: hour,
        startMinute: minute,
      );
      emit(ReminderLoaded(updatedSettings));
    }
  }

  void updateEndTime(int hour, int minute) {
    final s = state;
    if (s is ReminderLoaded) {
      final updatedSettings = s.settings.copyWith(
        endHour: hour,
        endMinute: minute,
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

          if (!kIsWeb) {
            if (settings.isEnabled) {
              await _reminderService.scheduleReminders(settings);
              // Show confirmation notification once
              try {
                await _reminderService.showConfirmation();
              } on Exception catch (e, stack) {
                unawaited(
                  AppLogger.error(
                    'Error showing confirmation reminder',
                    error: e,
                    stackTrace: stack,
                  ),
                );
              }
            } else {
              await _reminderService.cancelReminders();
            }
          }
          emit(ReminderLoaded(settings));
          return true;

      case ApiFailure(:final failure):
          unawaited(
            AppLogger.error(
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
