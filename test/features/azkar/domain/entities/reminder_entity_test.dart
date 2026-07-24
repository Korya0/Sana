import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

void main() {
  const baseReminder = ReminderEntity(
    id: '1',
    azkarId: '2',
    time: '08:00',
    repeatType: RepeatType.daily,
    days: <int>[],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  group('ReminderEntity', () {
    test('should create ReminderEntity with all required fields', () {
      const entity = baseReminder;

      expect(entity.id, '1');
      expect(entity.azkarId, '2');
      expect(entity.time, '08:00');
      expect(entity.repeatType, RepeatType.daily);
      expect(entity.days, <int>[]);
      expect(entity.isEnabled, true);
      expect(entity.timezone, 'Africa/Cairo');
      expect(entity.template, NotificationTemplate.morning);
    });

    group('hour getter', () {
      test('should return hour from time format "HH:mm"', () {
        final entity = baseReminder.copyWith(time: '14:30');
        expect(entity.hour, 14);
      });

      test('should return 0 if time is empty', () {
        final entity = baseReminder.copyWith(time: '');
        expect(entity.hour, 0);
      });

      test('should return 0 if time has no colon', () {
        final entity = baseReminder.copyWith(time: '1430');
        expect(entity.hour, 0);
      });
    });

    group('minute getter', () {
      test('should return minute from time format "HH:mm"', () {
        final entity = baseReminder.copyWith(time: '14:30');
        expect(entity.minute, 30);
      });

      test('should return 0 if time is empty', () {
        final entity = baseReminder.copyWith(time: '');
        expect(entity.minute, 0);
      });

      test('should return 0 if time has no colon', () {
        final entity = baseReminder.copyWith(time: '1430');
        expect(entity.minute, 0);
      });
    });

    group('copyWith()', () {
      test('should return a new instance with updated fields', () {
        final updated = baseReminder.copyWith(
          time: '09:00',
          isEnabled: false,
        );

        expect(updated.time, '09:00');
        expect(updated.isEnabled, false);
        expect(baseReminder.time, '08:00');
        expect(baseReminder.isEnabled, true);
      });

      test('copyWith() without parameters should return an equal instance', () {
        final copied = baseReminder.copyWith();
        expect(copied, equals(baseReminder));
        expect(copied, isNot(same(baseReminder)));
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        const a = baseReminder;
        final b = baseReminder.copyWith();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('should not be equal when fields differ', () {
        const a = baseReminder;
        final b = baseReminder.copyWith(id: '2');

        expect(a, isNot(equals(b)));
      });

      test('hashCode should be equal for equal objects', () {
        const a = baseReminder;
        final b = baseReminder.copyWith();

        expect(a.hashCode, equals(b.hashCode));
      });
    });

    group('allowedReminderCategoryIds', () {
      test('should contain only [2, 3, 4, 5]', () {
        expect(allowedReminderCategoryIds, ['2', '3', '4', '5']);
        expect(allowedReminderCategoryIds.length, 4);
      });
    });
  });
}
