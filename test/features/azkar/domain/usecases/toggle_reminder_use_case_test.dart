import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/toggle_reminder_use_case.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}
class MockNotificationScheduler extends Mock implements NotificationScheduler {}
class FakeNotificationRequest extends Fake implements NotificationRequest {}

void main() {
  late ToggleReminderUseCase useCase;
  late MockReminderRepository mockRepository;
  late MockNotificationScheduler mockScheduler;

  setUpAll(() {
    registerFallbackValue(FakeNotificationRequest());
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockScheduler = MockNotificationScheduler();
    useCase = ToggleReminderUseCase(mockRepository, mockScheduler);
  });

  const tId = '123';
  const tReminderEnabled = ReminderEntity(
    id: tId,
    azkarId: '2',
    time: '07:00',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  const tReminderDisabled = ReminderEntity(
    id: tId,
    azkarId: '2',
    time: '07:00',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: false,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  group('ToggleReminderUseCase', () {
    test('should update DB, cancel old and schedule new notifications when toggled ON', () async {
      // Arrange
      when(() => mockRepository.toggleReminder(tId, isEnabled: true))
          .thenAnswer((_) async => const Result.success(tReminderEnabled));
      when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
      when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

      // Act
      final result = await useCase(tId, isEnabled: true);

      // Assert
      expect(result, const Result<void>.success(null));
      verify(() => mockRepository.toggleReminder(tId, isEnabled: true)).called(1);
      verify(() => mockScheduler.cancel(any())).called(greaterThanOrEqualTo(1));
      verify(() => mockScheduler.schedule(any())).called(7);
    });

    test('should update DB, cancel old notifications and NOT schedule when toggled OFF', () async {
      // Arrange
      when(() => mockRepository.toggleReminder(tId, isEnabled: false))
          .thenAnswer((_) async => const Result.success(tReminderDisabled));
      when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});

      // Act
      final result = await useCase(tId, isEnabled: false);

      // Assert
      expect(result, const Result<void>.success(null));
      verify(() => mockRepository.toggleReminder(tId, isEnabled: false)).called(1);
      verify(() => mockScheduler.cancel(any())).called(greaterThanOrEqualTo(1));
      verifyNever(() => mockScheduler.schedule(any()));
    });

    test('should return Failure when DB toggle fails', () async {
      // Arrange
      when(() => mockRepository.toggleReminder(tId, isEnabled: true))
          .thenAnswer((_) async => const Result.failure(CacheFailure(message: 'Error')));

      // Act
      final result = await useCase(tId, isEnabled: true);

      // Assert
      expect(result, const Result<void>.failure(CacheFailure(message: 'Error')));
      verify(() => mockRepository.toggleReminder(tId, isEnabled: true)).called(1);
      verifyNever(() => mockScheduler.cancel(any()));
    });
  });
}
