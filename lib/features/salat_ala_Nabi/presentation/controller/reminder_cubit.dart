import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/notification_service.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit(this._repo, this._notificationService)
    : super(ReminderInitial()) {
    unawaited(_loadSettings());
  }
  final IReminderRepo _repo;
  final NotificationService _notificationService;
  ReminderSettings? _savedSettings;

  /// التحقق من وجود تغييرات غير محفوظة
  bool get hasUnsavedChanges {
    final currentState = state;
    if (currentState is! ReminderLoaded || _savedSettings == null) return false;
    return currentState.settings != _savedSettings;
  }

  Future<void> _loadSettings() async {
    emit(ReminderLoading());
    final result = await _repo.getSettings();

    result.fold(
      (failure) {
        unawaited(
          AppLogger.error('Error loading reminder settings: ${failure.message}'),
        );
        // Fallback to default if load fails
        final defaultSettings = ReminderSettings.defaultSettings();
        _savedSettings = defaultSettings;
        emit(ReminderLoaded(defaultSettings));
      },
      (settings) {
        _savedSettings = settings;
        emit(ReminderLoaded(settings));

        // [Web Support] تعطيل إعادة جدولة التنبيهات في الويب لأن Workmanager غير مدعوم
        if (!kIsWeb && settings.isEnabled) {
          unawaited(WorkManagerService.scheduleReminder(settings));
        }
      },
    );
  }

  Future<void> toggleReminder(bool value) async {
    final currentState = state;
    if (currentState is! ReminderLoaded) return;

    if (value) {
      if (kIsWeb) return;

      // طلب الأذونات قبل التفعيل
      final hasPermission = await _requestPermissions();
      if (!hasPermission) return;

      // تشغيل تذكير فوري عند التفعيل للتجربة
      try {
        await _notificationService.initialize();
        await _notificationService.showReminder();
      } catch (e, stack) {
        unawaited(
          AppLogger.error(
            'Error showing immediate reminder',
            error: e,
            stackTrace: stack,
          ),
        );
      }
    }

    final updatedSettings = currentState.settings.copyWith(isEnabled: value);
    emit(ReminderLoaded(updatedSettings));
  }

  void updateInterval(int minutes) {
    final currentState = state;
    if (currentState is! ReminderLoaded) return;

    final updatedSettings = currentState.settings.copyWith(
      intervalMinutes: minutes,
    );
    emit(ReminderLoaded(updatedSettings));
  }

  void updateWorkingHoursMode(int mode) {
    final currentState = state;
    if (currentState is! ReminderLoaded) return;

    ReminderSettings updatedSettings;
    switch (mode) {
      case WorkingHoursMode.allDay:
        updatedSettings = currentState.settings.copyWith(
          workingHoursMode: mode,
          startHour: 0,
          startMinute: 0,
          endHour: 23,
          endMinute: 59,
        );
      case WorkingHoursMode.defaultHours:
        updatedSettings = currentState.settings.copyWith(
          workingHoursMode: mode,
          startHour: 9,
          startMinute: 0,
          endHour: 17,
          endMinute: 0,
        );
      default:
        updatedSettings = currentState.settings.copyWith(workingHoursMode: mode);
    }
    emit(ReminderLoaded(updatedSettings));
  }

  void updateStartTime(int hour, int minute) {
    final currentState = state;
    if (currentState is! ReminderLoaded) return;

    final updatedSettings = currentState.settings.copyWith(
      startHour: hour,
      startMinute: minute,
    );
    emit(ReminderLoaded(updatedSettings));
  }

  void updateEndTime(int hour, int minute) {
    final currentState = state;
    if (currentState is! ReminderLoaded) return;

    final updatedSettings = currentState.settings.copyWith(
      endHour: hour,
      endMinute: minute,
    );
    emit(ReminderLoaded(updatedSettings));
  }

  Future<void> saveChanges() async {
    final currentState = state;
    if (currentState is! ReminderLoaded) return;

    final settings = currentState.settings;
    final result = await _repo.saveSettings(settings);

    await result.fold(
      (failure) async {
        unawaited(
          AppLogger.error('Error saving reminder settings: ${failure.message}'),
        );
      },
      (success) async {
        _savedSettings = settings;

        if (!kIsWeb) {
          if (settings.isEnabled) {
            await WorkManagerService.scheduleReminder(settings);
            try {
              await _notificationService.initialize();
              await _notificationService.showReminder();
            } catch (e, stack) {
              unawaited(
                AppLogger.error(
                  'Error showing immediate reminder',
                  error: e,
                  stackTrace: stack,
                ),
              );
            }
          } else {
            await WorkManagerService.cancelReminder();
          }
        }
        emit(ReminderLoaded(settings));
      },
    );
  }

  void discardChanges() {
    if (_savedSettings != null) {
      emit(ReminderLoaded(_savedSettings!));
    }
  }

  Future<bool> _requestPermissions() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.request();
        if (!status.isGranted) return false;
      }
    }
    return true;
  }
}
