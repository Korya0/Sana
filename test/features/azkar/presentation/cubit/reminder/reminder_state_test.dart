import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_state.dart';

void main() {
  group('ReminderInitial', () {
    test('equality should work correctly', () {
      expect(const ReminderInitial(), const ReminderInitial());
    });
  });

  group('ReminderLoading', () {
    test('equality should work correctly', () {
      expect(const ReminderLoading(), const ReminderLoading());
    });
  });

  group('ReminderLoaded', () {
    test('equality should compare reminders list with DeepCollectionEquality', () {
      final reminders1 = [
        const ReminderEntity(
          id: '1', azkarId: '2', time: '08:00',
          repeatType: RepeatType.daily, days: [], isEnabled: true,
          timezone: 'Cairo', template: NotificationTemplate.morning,
        ),
      ];
      final reminders2 = [
        const ReminderEntity(
          id: '1', azkarId: '2', time: '08:00',
          repeatType: RepeatType.daily, days: [], isEnabled: true,
          timezone: 'Cairo', template: NotificationTemplate.morning,
        ),
      ];

      expect(ReminderLoaded(reminders1), ReminderLoaded(reminders2));
    });
  });

  group('ReminderError', () {
    test('equality should compare message', () {
      const error1 = ReminderError('خطأ');
      const error2 = ReminderError('خطأ');
      const error3 = ReminderError('خطأ مختلف');

      expect(error1, error2);
      expect(error1, isNot(error3));
    });
  });
}
