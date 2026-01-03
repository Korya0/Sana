import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/notification_service.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';

class ReminderCubit extends Cubit<ReminderSettings?> {
  final ReminderRepo _repo;
  ReminderSettings? _savedSettings;

  ReminderCubit(this._repo) : super(null) {
    _loadSettings();
  }

  /// التحقق من وجود تغييرات غير محفوظة
  bool get hasUnsavedChanges {
    if (state == null || _savedSettings == null) return false;
    return state != _savedSettings;
  }

  Future<void> _loadSettings() async {
    final settings = await _repo.getSettings();
    _savedSettings = settings;
    emit(settings);

    // إعادة جدولة التذكير عند فتح التطبيق للتأكد من عمله
    if (settings.isEnabled) {
      await WorkManagerService.scheduleReminder(settings);
    }
  }

  Future<void> toggleReminder(bool value) async {
    if (state == null) return;

    if (value) {
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
      } catch (e) {
        debugPrint('Error showing immediate reminder: $e');
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
        break;
      case 1: // ساعات العمل الافتراضية
        updated = state!.copyWith(
          workingHoursMode: mode,
          startHour: 9,
          startMinute: 0,
          endHour: 17,
          endMinute: 0,
        );
        break;
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

    await _repo.saveSettings(state!);
    _savedSettings = state;

    // تطبيق الجدولة الجديدة
    if (state!.isEnabled) {
      await WorkManagerService.scheduleReminder(state!);

      // تشغيل تذكير فوري عند الحفظ للتأكيد (اختياري، لكن مفيد)
      try {
        final notificationService = NotificationService();
        await notificationService.initialize();
        await notificationService.showReminder();
      } catch (e) {
        debugPrint('Error showing immediate reminder on save: $e');
      }
    } else {
      await WorkManagerService.cancelReminder();
    }

    emit(state); // Re-emit to update UI if needed
  }

  /// إلغاء التغييرات والعودة للحفظ السابق
  void discardChanges() {
    if (_savedSettings != null) {
      emit(_savedSettings);
    }
  }

  /// طلب الأذونات اللازمة (Android 13+)
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
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
