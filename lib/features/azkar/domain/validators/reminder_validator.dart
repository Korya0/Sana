import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

class ReminderValidationResult {
  const ReminderValidationResult({this.errorMessage});

  final String? errorMessage;

  bool get isValid => errorMessage == null;
}

abstract class ReminderValidator {
  const ReminderValidator._();

  /// Validates a time string in "HH:mm" format.
  static ReminderValidationResult validateTime(String time) {
    if (time.isEmpty) {
      return const ReminderValidationResult(errorMessage: 'الرجاء تحديد وقت التذكير');
    }
    final parts = time.split(':');
    if (parts.length != 2) {
      return const ReminderValidationResult(errorMessage: 'صيغة الوقت غير صحيحة');
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return const ReminderValidationResult(errorMessage: 'صيغة الوقت غير صحيحة');
    }
    if (hour < 0 || hour > 23) {
      return const ReminderValidationResult(errorMessage: 'الساعة يجب أن تكون بين 0 و 23');
    }
    if (minute < 0 || minute > 59) {
      return const ReminderValidationResult(errorMessage: 'الدقيقة يجب أن تكون بين 0 و 59');
    }
    return const ReminderValidationResult();
  }

  /// Validates that custom repeat type has at least one day selected.
  static ReminderValidationResult validateDays(
    RepeatType repeatType,
    List<int> days,
  ) {
    if (repeatType == RepeatType.custom && days.isEmpty) {
      return const ReminderValidationResult(
        errorMessage: 'الرجاء اختيار يوم واحد على الأقل',
      );
    }
    return const ReminderValidationResult();
  }

  /// Validates the full reminder entity input.
  static ReminderValidationResult validate({
    required String time,
    required RepeatType repeatType,
    required List<int> days,
  }) {
    final timeResult = validateTime(time);
    if (!timeResult.isValid) return timeResult;

    final daysResult = validateDays(repeatType, days);
    if (!daysResult.isValid) return daysResult;

    return const ReminderValidationResult();
  }
}
