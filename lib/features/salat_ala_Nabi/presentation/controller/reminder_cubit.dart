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
    : super(const ReminderState.initial()) {
    unawaited(_loadSettings());
  }
  final IReminderRepo _repo;
  final NotificationService _notificationService;
  ReminderSettings? _savedSettings;

  /// التحقق من وجود تغييرات غير محفوظة
  bool get hasUnsavedChanges {
    return state.maybeWhen(
      loaded: (settings) =>
          _savedSettings != null && settings != _savedSettings,
      orElse: () => false,
    );
  }

  Future<void> _loadSettings() async {
    emit(const ReminderState.loading());
    final result = await _repo.getSettings();

    result.when(
      success: (settings) {
        _savedSettings = settings;
        emit(ReminderState.loaded(settings));

        // [Web Support] تعطيل إعادة جدولة التنبيهات في الويب لأن Workmanager غير مدعوم
        if (!kIsWeb && settings.isEnabled) {
          unawaited(WorkManagerService.scheduleReminder(settings));
        }
      },
      failure: (failure) {
        unawaited(
          AppLogger.error(
            'Error loading reminder settings: ${failure.message}',
          ),
        );
        // Fallback to default if load fails
        final defaultSettings = ReminderSettings.defaultSettings();
        _savedSettings = defaultSettings;
        emit(ReminderState.loaded(defaultSettings));
      },
    );
  }

  Future<void> toggleReminder({required bool value}) async {
    await state.maybeWhen(
      loaded: (settings) async {
        if (value) {
          if (kIsWeb) return;

          // طلب الأذونات قبل التفعيل
          final hasPermission = await _requestPermissions();
          if (!hasPermission) return;

          // تشغيل تذكير فوري عند التفعيل للتجربة
          try {
            await _notificationService.initialize();
            await _notificationService.showReminder();
          } on Exception catch (e, stack) {
            unawaited(
              AppLogger.error(
                'Error showing immediate reminder',
                error: e,
                stackTrace: stack,
              ),
            );
          }
        }

        final updatedSettings = settings.copyWith(isEnabled: value);
        emit(ReminderState.loaded(updatedSettings));
      },
      orElse: () {},
    );
  }

  void updateInterval(int minutes) {
    state.maybeWhen(
      loaded: (settings) {
        final updatedSettings = settings.copyWith(intervalMinutes: minutes);
        emit(ReminderState.loaded(updatedSettings));
      },
      orElse: () {},
    );
  }

  void updateWorkingHoursMode(int mode) {
    state.maybeWhen(
      loaded: (settings) {
        ReminderSettings updatedSettings;
        switch (mode) {
          case WorkingHoursMode.allDay:
            updatedSettings = settings.copyWith(
              workingHoursMode: mode,
              startHour: 0,
              startMinute: 0,
              endHour: 23,
              endMinute: 59,
            );
          case WorkingHoursMode.defaultHours:
            updatedSettings = settings.copyWith(
              workingHoursMode: mode,
              startHour: 9,
              startMinute: 0,
              endHour: 17,
              endMinute: 0,
            );
          default:
            updatedSettings = settings.copyWith(workingHoursMode: mode);
        }
        emit(ReminderState.loaded(updatedSettings));
      },
      orElse: () {},
    );
  }

  void updateStartTime(int hour, int minute) {
    state.maybeWhen(
      loaded: (settings) {
        final updatedSettings = settings.copyWith(
          startHour: hour,
          startMinute: minute,
        );
        emit(ReminderState.loaded(updatedSettings));
      },
      orElse: () {},
    );
  }

  void updateEndTime(int hour, int minute) {
    state.maybeWhen(
      loaded: (settings) {
        final updatedSettings = settings.copyWith(
          endHour: hour,
          endMinute: minute,
        );
        emit(ReminderState.loaded(updatedSettings));
      },
      orElse: () {},
    );
  }

  Future<void> saveChanges() async {
    await state.maybeWhen(
      loaded: (settings) async {
        final result = await _repo.saveSettings(settings);

        await result.when(
          success: (_) async {
            _savedSettings = settings;

            if (!kIsWeb) {
              if (settings.isEnabled) {
                await WorkManagerService.scheduleReminder(settings);
                try {
                  await _notificationService.initialize();
                  await _notificationService.showReminder();
                } on Exception catch (e, stack) {
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
            emit(ReminderState.loaded(settings));
          },
          failure: (failure) async {
            unawaited(
              AppLogger.error(
                'Error saving reminder settings: ${failure.message}',
              ),
            );
          },
        );
      },
      orElse: () async {},
    );
  }

  void discardChanges() {
    if (_savedSettings != null) {
      emit(ReminderState.loaded(_savedSettings!));
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
