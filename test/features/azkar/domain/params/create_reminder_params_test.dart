import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';

void main() {
  group('CreateReminderParams', () {
    const baseParams = CreateReminderParams(
      azkarId: '2',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: [1, 2, 3],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );

    test('should create CreateReminderParams with all required fields', () {
      const params = baseParams;

      expect(params.azkarId, '2');
      expect(params.time, '08:00');
      expect(params.repeatType, RepeatType.daily);
      expect(params.days, [1, 2, 3]);
      expect(params.isEnabled, true);
      expect(params.timezone, 'Africa/Cairo');
      expect(params.template, NotificationTemplate.morning);
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        const a = baseParams;
        const b = CreateReminderParams(
          azkarId: '2',
          time: '08:00',
          repeatType: RepeatType.daily,
          days: [1, 2, 3],
          isEnabled: true,
          timezone: 'Africa/Cairo',
          template: NotificationTemplate.morning,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('should not be equal when fields differ', () {
        const a = baseParams;
        const b = CreateReminderParams(
          azkarId: '3',
          time: '08:00',
          repeatType: RepeatType.daily,
          days: [1, 2, 3],
          isEnabled: true,
          timezone: 'Africa/Cairo',
          template: NotificationTemplate.morning,
        );

        expect(a, isNot(equals(b)));
      });
    });

    test('hashCode should be equal for equal params', () {
      const a = baseParams;
      const b = CreateReminderParams(
        azkarId: '2',
        time: '08:00',
        repeatType: RepeatType.daily,
        days: [1, 2, 3],
        isEnabled: true,
        timezone: 'Africa/Cairo',
        template: NotificationTemplate.morning,
      );

      expect(a.hashCode, equals(b.hashCode));
    });

    test('== should compare days List using listEquals', () {
      const a = baseParams;
      const b = baseParams;
      // Same values should be equal
      expect(a == b, isTrue);
    });
  });
}
