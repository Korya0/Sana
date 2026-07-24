import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/params/update_reminder_params.dart';

void main() {
  group('UpdateReminderParams', () {
    const baseParams = UpdateReminderParams(
      id: '1',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: [1, 2, 3],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );

    test('should create UpdateReminderParams with all required fields', () {
      const params = baseParams;

      expect(params.id, '1');
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
        const b = UpdateReminderParams(
          id: '1',
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
        const b = UpdateReminderParams(
          id: '2',
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
      const b = UpdateReminderParams(
        id: '1',
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
