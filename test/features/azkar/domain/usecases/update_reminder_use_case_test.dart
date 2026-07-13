import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/update_reminder_use_case.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';

class MockReminderRepository extends Mock implements IReminderRepository {}
class MockNotificationScheduler extends Mock implements INotificationScheduler {}
class FakeReminderEntity extends Fake implements ReminderEntity {}
class FakeNotificationRequest extends Fake implements NotificationRequest {}

void main() {
  late UpdateReminderUseCase useCase;
  late MockReminderRepository mockRepository;
  late MockNotificationScheduler mockScheduler;

  setUpAll(() {
    registerFallbackValue(FakeReminderEntity());
    registerFallbackValue(FakeNotificationRequest());
  });

  setUp(() {
    mockRepository = MockReminderRepository();
    mockScheduler = MockNotificationScheduler();
    useCase = UpdateReminderUseCase(mockRepository, mockScheduler);
  });

  const tReminderEnabled = ReminderEntity(
    id: '123',
    azkarId: '2',
    time: '08:00',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  group('UpdateReminderUseCase', () {
    test('should update DB, cancel old and schedule new notifications when updated and enabled', () async {
      // Arrange
      when(() => mockRepository.updateReminder(any()))
          .thenAnswer((_) async => const Result.success(null));
      when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});
      when(() => mockScheduler.schedule(any())).thenAnswer((_) async {});

      // Act
      final result = await useCase(tReminderEnabled);

      // Assert
      expect(result, const Result<void>.success(null));
      verify(() => mockRepository.updateReminder(tReminderEnabled)).called(1);
      verify(() => mockScheduler.cancel(any())).called(greaterThanOrEqualTo(1));
      verify(() => mockScheduler.schedule(any())).called(7);
    });

    test('should return Failure when repository fails', () async {
      // Arrange
      when(() => mockRepository.updateReminder(any()))
          .thenAnswer((_) async => const Result.failure(CacheFailure(message: 'Update Failed')));

      // Act
      final result = await useCase(tReminderEnabled);

      // Assert
      expect(result, const Result<void>.failure(CacheFailure(message: 'Update Failed')));
      verify(() => mockRepository.updateReminder(tReminderEnabled)).called(1);
      verifyNever(() => mockScheduler.cancel(any()));
    });
  });
}
