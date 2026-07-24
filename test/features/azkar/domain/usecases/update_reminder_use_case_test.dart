import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/notification/models/notification_payload.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reminder_use_case.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}
class MockNotificationScheduler extends Mock implements NotificationScheduler {}

void main() {
  late UpdateReminderUseCase useCase;
  late MockReminderRepository mockRepository;
  late MockNotificationScheduler mockScheduler;

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

  setUpAll(() {
    registerFallbackValue(const ReminderEntity(
      id: '',
      azkarId: '',
      time: '',
      repeatType: RepeatType.once,
      days: [],
      isEnabled: false,
      timezone: '',
      template: NotificationTemplate.general,
    ));
    registerFallbackValue(NotificationRequest(
      id: 0,
      title: '',
      body: '',
      scheduledDateTime: DateTime(2000),
      payload: const NotificationPayload(id: '', type: ''),
    ));
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockScheduler = MockNotificationScheduler();
    useCase = UpdateReminderUseCase(mockRepository, mockScheduler);
  });

  test('call(reminder) should invoke repository.updateReminder(reminder)', () async {
    when(() => mockRepository.updateReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    await useCase.call(reminder);

    verify(() => mockRepository.updateReminder(reminder)).called(1);
  });

  test('call(reminder) should cancel old notifications on success', () async {
    when(() => mockRepository.updateReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    await useCase.call(reminder);

    verify(() => mockScheduler.cancel(reminder.id.hashCode)).called(1);
  });

  test('call(reminder) should schedule new notification if enabled after update', () async {
    when(() => mockRepository.updateReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    await useCase.call(reminder);

    verify(() => mockScheduler.schedule(any())).called(1);
  });

  test('call(reminder) should NOT schedule if reminder is disabled', () async {
    final disabledReminder = reminder.copyWith(isEnabled: false);
    when(() => mockRepository.updateReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});

    await useCase.call(disabledReminder);

    verifyNever(() => mockScheduler.schedule(any()));
  });

  test('call(reminder) should NOT cancel/schedule if update fails', () async {
    when(() => mockRepository.updateReminder(any())).thenAnswer(
      (_) async => const Result.failure(
        CacheFailure(message: 'Update failed'),
      ),
    );

    await useCase.call(reminder);

    verifyNever(() => mockScheduler.cancel(any()));
    verifyNever(() => mockScheduler.schedule(any()));
  });

  test('call(reminder) should return the result from repository', () async {
    when(() => mockRepository.updateReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    final result = await useCase.call(reminder);

    expect(result, isA<Success<void>>());
  });
}
