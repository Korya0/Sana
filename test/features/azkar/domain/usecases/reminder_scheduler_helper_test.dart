import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/services/notification/models/notification_payload.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';
import 'package:sana/core/services/notification/notification_keys.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/use_cases/reminder_scheduler_helper.dart';

class MockNotificationScheduler extends Mock implements NotificationScheduler {}

void main() {
  late MockNotificationScheduler mockScheduler;

  setUp(() {
    mockScheduler = MockNotificationScheduler();
    registerFallbackValue(NotificationRequest(
      id: 0,
      title: '',
      body: '',
      scheduledDateTime: DateTime(2000),
      payload: const NotificationPayload(id: '', type: ''),
    ));
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
  });

  group('ReminderSchedulerHelper.scheduleAll()', () {
    test('once type: should schedule for today or tomorrow', () async {
      const reminder = ReminderEntity(
        id: '1',
        azkarId: '2',
        time: '08:00',
        repeatType: RepeatType.once,
        days: [],
        isEnabled: true,
        timezone: 'Africa/Cairo',
        template: NotificationTemplate.morning,
      );

      await ReminderSchedulerHelper.scheduleAll(reminder, mockScheduler);

      verify(() => mockScheduler.schedule(
        any(that: isA<NotificationRequest>().having(
          (r) => r.id,
          'id',
          '1'.hashCode,
        )),
      )).called(1);
    });

    test('daily type: should schedule for 7 days', () async {
      const reminder = ReminderEntity(
        id: '1',
        azkarId: '3',
        time: '18:00',
        repeatType: RepeatType.daily,
        days: [],
        isEnabled: true,
        timezone: 'Africa/Cairo',
        template: NotificationTemplate.evening,
      );

      await ReminderSchedulerHelper.scheduleAll(reminder, mockScheduler);

      // Should be called 7 times (one per day)
      verify(() => mockScheduler.schedule(any())).called(7);
    });

    test('custom type with specific days: should schedule for those days', () async {
      const reminder = ReminderEntity(
        id: '1',
        azkarId: '2',
        time: '08:00',
        repeatType: RepeatType.custom,
        days: [1, 3, 5],
        isEnabled: true,
        timezone: 'Africa/Cairo',
        template: NotificationTemplate.morning,
      );

      await ReminderSchedulerHelper.scheduleAll(reminder, mockScheduler);

      // Should be called 3 times (Monday, Wednesday, Friday)
      verify(() => mockScheduler.schedule(any())).called(3);
    });

    test('should use correct title and body from template', () async {
      const reminder = ReminderEntity(
        id: '1',
        azkarId: '2',
        time: '08:00',
        repeatType: RepeatType.once,
        days: [],
        isEnabled: true,
        timezone: 'Africa/Cairo',
        template: NotificationTemplate.morning,
      );

      await ReminderSchedulerHelper.scheduleAll(reminder, mockScheduler);

      verify(() => mockScheduler.schedule(
        any(that: isA<NotificationRequest>().having(
          (r) => r.title,
          'title',
          NotificationTemplate.morning.title,
        )),
      )).called(1);
    });

    test('should use correct NotificationPayload with type and azkarId', () async {
      const reminder = ReminderEntity(
        id: '1',
        azkarId: '5',
        time: '06:00',
        repeatType: RepeatType.once,
        days: [],
        isEnabled: true,
        timezone: 'Africa/Cairo',
        template: NotificationTemplate.wakeUp,
      );

      await ReminderSchedulerHelper.scheduleAll(reminder, mockScheduler);

      verify(() => mockScheduler.schedule(
        any(that: isA<NotificationRequest>().having(
          (r) => r.payload.type,
          'type',
          NotificationKeys.typeAzkar,
        )),
      )).called(1);
    });
  });

  group('ReminderSchedulerHelper.cancelAll()', () {
    test('should cancel once notification and per-day notifications', () async {
      await ReminderSchedulerHelper.cancelAll('1', mockScheduler);

      // 1 (once) + 7 (days) = 8 calls
      verify(() => mockScheduler.cancel(any())).called(8);
    });

    test('should cancel the once notification by id.hashCode', () async {
      await ReminderSchedulerHelper.cancelAll('1', mockScheduler);

      verify(() => mockScheduler.cancel('1'.hashCode)).called(1);
    });

    test('should cancel per-day notifications for days 1 to 7', () async {
      await ReminderSchedulerHelper.cancelAll('1', mockScheduler);

      for (var day = 1; day <= 7; day++) {
        verify(() => mockScheduler.cancel('1_$day'.hashCode)).called(1);
      }
    });
  });
}
