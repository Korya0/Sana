import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/notification/models/notification_payload.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/create_reminder_use_case.dart';

class MockIReminderRepository extends Mock implements IReminderRepository {}
class MockINotificationScheduler extends Mock implements INotificationScheduler {}

void main() {
  late CreateReminderUseCase useCase;
  late MockIReminderRepository mockRepository;
  late MockINotificationScheduler mockScheduler;

  const testParams = CreateReminderParams(
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
    useCase = CreateReminderUseCase(mockRepository, mockScheduler);
  });

  test('call(params) should check no existing reminder for the category', () async {
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );
    when(() => mockRepository.createReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    await useCase.call(testParams);

    verify(() => mockRepository.getReminders('2')).called(1);
  });

  test('call(params) should return Result.failure if reminder already exists', () async {
    const existingReminder = ReminderEntity(
      id: '1',
      azkarId: '2',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: [],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );
    when(() => mockRepository.getReminders('2')).thenAnswer(
      (_) async => const Result.success([existingReminder]),
    );

    final result = await useCase.call(testParams);

    expect(result, isA<FailureResult<void>>());
    expect((result as FailureResult).failure.message, AppStrings.reminderAlreadyExists);
    verifyNever(() => mockRepository.createReminder(any()));
  });

  test('call(params) should create ReminderEntity with id from DateTime', () async {
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );
    when(() => mockRepository.createReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    await useCase.call(testParams);

    verify(() => mockRepository.createReminder(
      any(that: isA<ReminderEntity>().having(
        (e) => e.azkarId,
        'azkarId',
        '2',
      )),
    )).called(1);
  });

  test('call(params) should save reminder in repository', () async {
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );
    when(() => mockRepository.createReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    final result = await useCase.call(testParams);

    expect(result, isA<Success<void>>());
    verify(() => mockRepository.createReminder(any())).called(1);
  });

  test('call(params) should schedule if reminder is enabled and saved successfully', () async {
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );
    when(() => mockRepository.createReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    await useCase.call(testParams);

    verify(() => mockScheduler.schedule(any())).called(1);
  });

  test('call(params) should NOT schedule if reminder is disabled', () async {
    const disabledParams = CreateReminderParams(
      azkarId: '3',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: [],
      isEnabled: false,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );
    when(() => mockRepository.createReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );

    await useCase.call(disabledParams);

    verifyNever(() => mockScheduler.schedule(any()));
  });

  test('call(params) should NOT schedule if save failed', () async {
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );
    when(() => mockRepository.createReminder(any())).thenAnswer(
      (_) async => const Result.failure(
        ReminderFailure(message: 'Save failed'),
      ),
    );

    await useCase.call(testParams);

    verifyNever(() => mockScheduler.schedule(any()));
  });

  test('call(params) should return the result from repository', () async {
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );
    when(() => mockRepository.createReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

    final result = await useCase.call(testParams);

    expect(result, isA<Success<void>>());
  });
}
