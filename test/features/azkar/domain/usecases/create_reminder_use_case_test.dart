import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/create_reminder_use_case.dart';

class MockReminderRepository extends Mock implements IReminderRepository {}

class MockNotificationScheduler extends Mock implements INotificationScheduler {}

class FakeReminderEntity extends Fake implements ReminderEntity {}

class FakeNotificationRequest extends Fake implements NotificationRequest {}

void main() {
  late CreateReminderUseCase useCase;
  late MockReminderRepository mockRepository;
  late MockNotificationScheduler mockScheduler;

  setUpAll(() {
    registerFallbackValue(FakeReminderEntity());
    registerFallbackValue(FakeNotificationRequest());
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockScheduler = MockNotificationScheduler();
    useCase = CreateReminderUseCase(mockRepository, mockScheduler);
  });

  const tParams = CreateReminderParams(
    azkarId: '2', // Morning
    time: '07:00',
    repeatType: RepeatType.daily,
    days: [1, 2, 3, 4, 5, 6, 7],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  const tExistingReminder = ReminderEntity(
    id: '123',
    azkarId: '2',
    time: '06:00',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  group('CreateReminderUseCase', () {
    test(
      'should return Failure(ReminderFailure) when a reminder already exists for the category',
      () async {
        // Arrange
        when(
          () => mockRepository.getReminders(tParams.azkarId),
        ).thenAnswer((_) async => const Result.success([tExistingReminder]));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(
          result,
          const Result<void>.failure(
            ReminderFailure(message: AppStrings.reminderAlreadyExists),
          ),
        );
        verify(() => mockRepository.getReminders(tParams.azkarId)).called(1);
        verifyNever(() => mockRepository.createReminder(any()));
      },
    );

    test(
      'should create reminder and schedule it when no reminder exists for the category and isEnabled is true',
      () async {
        // Arrange
        when(
          () => mockRepository.getReminders(tParams.azkarId),
        ).thenAnswer((_) async => const Result.success([]));
        when(
          () => mockRepository.createReminder(any()),
        ).thenAnswer((_) async => const Result<void>.success(null));
        when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, const Result<void>.success(null));
        verify(() => mockRepository.getReminders(tParams.azkarId)).called(1);
        verify(() => mockRepository.createReminder(any())).called(1);
        // Since it's daily and enabled, it should call schedule for all 7 days
        verify(() => mockScheduler.schedule(any())).called(7);
      },
    );

    test('should return Failure from repository when creation fails', () async {
      // Arrange
      when(
        () => mockRepository.getReminders(tParams.azkarId),
      ).thenAnswer((_) async => const Result.success([]));
      when(() => mockRepository.createReminder(any())).thenAnswer(
        (_) async => const Result.failure(CacheFailure(message: 'DB Error')),
      );

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(
        result,
        const Result<void>.failure(CacheFailure(message: 'DB Error')),
      );
      verify(() => mockRepository.getReminders(tParams.azkarId)).called(1);
      verify(() => mockRepository.createReminder(any())).called(1);
      verifyNever(() => mockScheduler.schedule(any()));
    });
  });
}
