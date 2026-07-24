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
import 'package:sana/features/azkar/domain/usecases/toggle_reminder_use_case.dart';

class MockIReminderRepository extends Mock implements IReminderRepository {}
class MockINotificationScheduler extends Mock implements INotificationScheduler {}

void main() {
  late ToggleReminderUseCase useCase;
  late MockIReminderRepository mockRepository;
  late MockINotificationScheduler mockScheduler;

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
    mockRepository = MockIReminderRepository();
    mockScheduler = MockINotificationScheduler();
    useCase = ToggleReminderUseCase(mockRepository, mockScheduler);
  });

  test('call(id, isEnabled: true) should invoke repository.toggleReminder', () async {
    when(() => mockRepository.toggleReminder(any(), isEnabled: any(named: 'isEnabled')))
        .thenAnswer((_) async => const Result.success(reminder));
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    await useCase.call('1', isEnabled: true);

    verify(() => mockRepository.toggleReminder('1', isEnabled: true)).called(1);
  });

  test('call(id, isEnabled: true) should cancel and then schedule on success', () async {
    when(() => mockRepository.toggleReminder(any(), isEnabled: any(named: 'isEnabled')))
        .thenAnswer((_) async => const Result.success(reminder));
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    final result = await useCase.call('1', isEnabled: true);

    // cancelAll calls cancel 8 times (1 for once + 7 for per-day)
    verify(() => mockScheduler.cancel(any())).called(8);
    // scheduleAll for RepeatType.once: 1 call
    verify(() => mockScheduler.schedule(any())).called(1);
    expect(result, isA<Success<void>>());
  });

  test('call(id, isEnabled: false) should cancel without scheduling', () async {
    when(() => mockRepository.toggleReminder(any(), isEnabled: any(named: 'isEnabled')))
        .thenAnswer((_) async => const Result.success(reminder));
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});

    final result = await useCase.call('1', isEnabled: false);

    // cancelAll calls cancel 8 times (1 for once + 7 for per-day)
    verify(() => mockScheduler.cancel(any())).called(8);
    verifyNever(() => mockScheduler.schedule(any()));
    expect(result, isA<Success<void>>());
  });

  test('call(id) should return Result.failure if toggle fails in repository', () async {
    when(() => mockRepository.toggleReminder(any(), isEnabled: any(named: 'isEnabled')))
        .thenAnswer((_) async => const Result.failure(
          CacheFailure(message: 'Toggle failed'),
        ));

    final result = await useCase.call('1', isEnabled: true);

    expect(result, isA<FailureResult<void>>());
    verifyNever(() => mockScheduler.cancel(any()));
    verifyNever(() => mockScheduler.schedule(any()));
  });

  test('call(id, isEnabled: true) should return Result.success(null) on success', () async {
    when(() => mockRepository.toggleReminder(any(), isEnabled: any(named: 'isEnabled')))
        .thenAnswer((_) async => const Result.success(reminder));
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    final result = await useCase.call('1', isEnabled: true);

    expect(result, isA<Success<void>>());
    expect((result as Success).data, isNull);
  });
}
