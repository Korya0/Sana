import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/validators/reminder_validator.dart';

void main() {
  group('ReminderValidationResult', () {
    test('isValid should be true when errorMessage is null', () {
      const result = ReminderValidationResult();
      expect(result.isValid, isTrue);
    });

    test('isValid should be false when errorMessage is not null', () {
      const result = ReminderValidationResult(errorMessage: 'خطأ');
      expect(result.isValid, isFalse);
    });
  });

  group('ReminderValidator.validateTime()', () {
    test('empty string should return error message', () {
      final result = ReminderValidator.validateTime('');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'الرجاء تحديد وقت التذكير');
    });

    test('abc should return error (no colon)', () {
      final result = ReminderValidator.validateTime('abc');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'صيغة الوقت غير صحيحة');
    });

    test('ab:cd should return error (non-numeric)', () {
      final result = ReminderValidator.validateTime('ab:cd');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'صيغة الوقت غير صحيحة');
    });

    test('25:00 should return error about hour range', () {
      final result = ReminderValidator.validateTime('25:00');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'الساعة يجب أن تكون بين 0 و 23');
    });

    test('-1:00 should return error about hour range', () {
      final result = ReminderValidator.validateTime('-1:00');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'الساعة يجب أن تكون بين 0 و 23');
    });

    test('10:60 should return error about minute range', () {
      final result = ReminderValidator.validateTime('10:60');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'الدقيقة يجب أن تكون بين 0 و 59');
    });

    test('10:-1 should return error about minute range', () {
      final result = ReminderValidator.validateTime('10:-1');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'الدقيقة يجب أن تكون بين 0 و 59');
    });

    test('00:00 should be valid', () {
      final result = ReminderValidator.validateTime('00:00');
      expect(result.isValid, isTrue);
    });

    test('23:59 should be valid', () {
      final result = ReminderValidator.validateTime('23:59');
      expect(result.isValid, isTrue);
    });

    test('12:30 should be valid', () {
      final result = ReminderValidator.validateTime('12:30');
      expect(result.isValid, isTrue);
    });
  });

  group('ReminderValidator.validateDays()', () {
    test('custom with empty days should return error', () {
      final result = ReminderValidator.validateDays(RepeatType.custom, []);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, 'الرجاء اختيار يوم واحد على الأقل');
    });

    test('custom with days should be valid', () {
      final result = ReminderValidator.validateDays(RepeatType.custom, [1, 3]);
      expect(result.isValid, isTrue);
    });

    test('daily with empty days should be valid', () {
      final result = ReminderValidator.validateDays(RepeatType.daily, []);
      expect(result.isValid, isTrue);
    });

    test('once with empty days should be valid', () {
      final result = ReminderValidator.validateDays(RepeatType.once, []);
      expect(result.isValid, isTrue);
    });
  });

  group('ReminderValidator.validate()', () {
    test('should fail if time is invalid', () {
      final result = ReminderValidator.validate(
        time: '',
        repeatType: RepeatType.daily,
        days: [],
      );
      expect(result.isValid, isFalse);
    });

    test('should fail if days are invalid (custom with no days)', () {
      final result = ReminderValidator.validate(
        time: '12:00',
        repeatType: RepeatType.custom,
        days: [],
      );
      expect(result.isValid, isFalse);
    });

    test('should succeed if both time and days are valid', () {
      final result = ReminderValidator.validate(
        time: '12:30',
        repeatType: RepeatType.daily,
        days: [],
      );
      expect(result.isValid, isTrue);
    });
  });
}
