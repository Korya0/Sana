import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/notification_service.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';

class ReminderCubit extends Cubit<ReminderSettings?> {
  ReminderCubit(this._repo) : super(null) {
    unawaited(_loadSettings());
  }
  final ReminderRepo _repo;
  ReminderSettings? _savedSettings;

  /// التحقق من وجود تغييرات غير محفوظة
  bool get hasUnsavedChanges {
    if (state == null || _savedSettings == null) return false;
    return state != _savedSettings;
  }

  Future<void> _loadSettings() async {
    final result = await _repo.getSettings();

    await result.fold(
      (failure) async {
        await AppLogger.error(
          'Error loading reminder settings: ${failure.message}',
          error: failure.technicalMessage,
        );
        // Fallback to default if load fails
        final defaultSettings = ReminderSettings.defaultSettings();
        _savedSettings = defaultSettings;
        emit(defaultSettings);
      },
      (settings) {
        _savedSettings = settings;
        emit(settings);

        // [Web Support] تعطيل إعادة جدولة التنبيهات في الويب لأن Workmanager غير مدعوم
        if (!kIsWeb && settings.isEnabled) {
          unawaited(WorkManagerService.scheduleReminder(settings));
        }
      },
    );
  }

  Future<void> toggleReminder(bool value) async {
    if (state == null) return;

    if (value) {
      if (kIsWeb) {
        // [Web Support] يتم التعامل مع التنبيه في الـ UI لإظهار الـ Toast للمستخدم
        return;
      }

      // طلب الأذونات قبل التفعيل
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        // إذا لم يوافق المستخدم، لا نغير الحالة
        return;
      }

      // تشغيل تذكير فوري عند التفعيل للتجربة
      try {
        final notificationService = NotificationService();
        await notificationService.initialize();
        await notificationService.showReminder();
      } on Exception catch (e) {
        await AppLogger.error('Error showing immediate reminder', error: e);
      }
    }

    final updated = state!.copyWith(isEnabled: value);
    emit(updated);
  }

  void updateInterval(int minutes) {
    if (state == null) return;
    final updated = state!.copyWith(intervalMinutes: minutes);
    emit(updated);
  }

  void updateWorkingHoursMode(int mode) {
    if (state == null) return;

    // تطبيق الأوضاع الافتراضية
    ReminderSettings updated;
    switch (mode) {
      case 0: // طوال اليوم
        updated = state!.copyWith(
          workingHoursMode: mode,
          startHour: 0,
          startMinute: 0,
          endHour: 23,
          endMinute: 59,
        );
      case 1: // ساعات العمل الافتراضية
        updated = state!.copyWith(
          workingHoursMode: mode,
          startHour: 9,
          startMinute: 0,
          endHour: 17,
          endMinute: 0,
        );
      default: // مخصص
        updated = state!.copyWith(workingHoursMode: mode);
    }
    emit(updated);
  }

  void updateStartTime(int hour, int minute) {
    if (state == null) return;
    final updated = state!.copyWith(startHour: hour, startMinute: minute);
    emit(updated);
  }

  void updateEndTime(int hour, int minute) {
    if (state == null) return;
    final updated = state!.copyWith(endHour: hour, endMinute: minute);
    emit(updated);
  }

  /// حفظ التغييرات وتطبيقها
  Future<void> saveChanges() async {
    if (state == null) return;

    final result = await _repo.saveSettings(state!);

    await result.fold(
      (failure) async {
        await AppLogger.error(
          'Error saving reminder settings: ${failure.message}',
          error: failure.technicalMessage,
        );
        // Optionally notify UI of failure here (e.g., via a side-effect stream)
      },
      (success) async {
        _savedSettings = state;

        if (!kIsWeb) {
          // [Web Support] تطبيق الجدولة الجديدة في الموبايل فقط
          if (state!.isEnabled) {
            await WorkManagerService.scheduleReminder(state!);

            // تشغيل تذكير فوري عند الحفظ للتأكيد
            try {
              final notificationService = NotificationService();
              await notificationService.initialize();
              await notificationService.showReminder();
            } on Exception catch (e) {
              unawaited(
                AppLogger.error('Error showing immediate reminder', error: e),
              );
            }
          } else {
            await WorkManagerService.cancelReminder();
          }
        }

        emit(state); // Re-emit to update UI if needed
      },
    );
  }

  /// إلغاء التغييرات والعودة للحفظ السابق
  void discardChanges() {
    if (_savedSettings != null) {
      emit(_savedSettings);
    }
  }

  /// طلب الأذونات اللازمة (Android 13+)
  Future<bool> _requestPermissions() async {
    // [Web Support] استخدام platform-independent check بدلاً من dart:io
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      // Android 13+ يحتاج إذن الإشعارات
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.request();
        if (!status.isGranted) {
          return false;
        }
      }
    }
    return true;
  }
}
