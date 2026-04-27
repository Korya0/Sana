import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/data/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit(
    this._repo,
    this._notificationService,
    this._workManagerService,
    this._permissionsManager,
    this._deviceInfoService,
  ) : super(const ReminderInitial()) {
    unawaited(loadSettings());
  }
  final IReminderRepository _repo;
  final INotificationService _notificationService;
  final IWorkManagerService _workManagerService;
  final IAppPermissionsManager _permissionsManager;
  final IDeviceInfoService _deviceInfoService;
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

    result.when(
      success: (settings) {
        _savedSettings = settings;
        emit(ReminderLoaded(settings));

        if (!kIsWeb && settings.isEnabled) {
          unawaited(_scheduleReminder(settings));
        }
      },
      failure: (failure) {
        unawaited(
          AppLogger.error(
            'Error loading reminder settings: ${failure.message}',
          ),
        );
        // Fallback to default if load fails
        final defaultSettings = ReminderSettingsModel.defaultSettings();
        _savedSettings = defaultSettings;
        emit(ReminderLoaded(defaultSettings));
      },
    );
  }

  Future<void> toggleReminder({required bool value}) async {
    final s = state;
    if (s is ReminderLoaded) {
      if (value) {
        if (kIsWeb) return;

        final hasPermission = await _requestPermissions();
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
            startHour: 9,
            startMinute: 0,
            endHour: 17,
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

      return await result.when(
        success: (_) async {
          _savedSettings = settings;

          if (!kIsWeb) {
            if (settings.isEnabled) {
              await _scheduleReminder(settings);
              // Show confirmation notification once
              try {
                await _notificationService.initialize();
                await _notificationService.show(
                  id: AppSalawatConstants.notificationBaseId,
                  title: AppStrings.salatAlaNabiTitle,
                  body: AppStrings.salatAlaNabiNotificationBody,
                  channelId: AppSalawatConstants.channelId,
                  channelName: AppSalawatConstants.channelName,
                  channelDescription: AppSalawatConstants.channelDescription,
                  soundFileName: AppSalawatConstants.soundFileName,
                );
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
              await _cancelSalawatReminders();
            }
          }
          emit(ReminderLoaded(settings));
          return true;
        },
        failure: (failure) async {
          unawaited(
            AppLogger.error(
              'Error saving reminder settings: ${failure.message}',
            ),
          );
          return false;
        },
      );
    }
    return false;
  }

  void discardChanges() {
    if (_savedSettings != null) {
      emit(ReminderLoaded(_savedSettings!));
    }
  }

  Future<void> _scheduleReminder(ReminderSettingsModel settings) async {
    // 1. Cancel previous salawat tasks
    await _cancelSalawatReminders();

    if (!settings.isEnabled) return;

    // 2. Register periodic task in WorkManager
    // This is the primary way we handle reminders now, without timezone library.
    // Interval is taken from user settings (minimum 15 mins by WorkManager policy).
    await _workManagerService.registerPeriodicTask(
      uniqueName: AppSalawatConstants.uniqueWorkName,
      taskName: AppSalawatConstants.taskName,
      frequency: Duration(minutes: settings.intervalMinutes),
      inputData: settings.toJson(),
    );
  }

  Future<void> _cancelSalawatReminders() async {
    // Cancel the background task
    await _workManagerService.cancelByUniqueName(
      AppSalawatConstants.uniqueWorkName,
    );

    // Cancel notifications
    await _notificationService.cancel(0);
    await _notificationService.cancel(AppSalawatConstants.notificationBaseId);
    await _notificationService.cancel(AppSalawatConstants.notificationBaseId + 100);
  }

  Future<bool> _requestPermissions() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final sdkInt = await _deviceInfoService.getAndroidSdkInt();
      if (sdkInt >= 33) {
        final status = await _permissionsManager.requestPermission(
          Permission.notification,
        );
        return status.isGranted;
      }
    }
    return true;
  }
}
