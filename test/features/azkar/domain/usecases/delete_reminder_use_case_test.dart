import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/delete_reminder_use_case.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}
class MockNotificationScheduler extends Mock implements NotificationScheduler {}

void main() {
  late DeleteReminderUseCase useCase;
  late MockReminderRepository mockRepository;
  late MockNotificationScheduler mockScheduler;

  setUp(() {
    mockRepository = MockReminderRepository();
    mockScheduler = MockNotificationScheduler();
    useCase = DeleteReminderUseCase(mockRepository, mockScheduler);
  });

  const tId = '123';

  group('DeleteReminderUseCase', () {
    test('should delete reminder from repository and cancel scheduled notifications on success', () async {
      // Arrange
      when(() => mockRepository.deleteReminder(tId))
          .thenAnswer((_) async => const Result.success(null));
      when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});

      // Act
      final result = await useCase(tId);

      // Assert
      expect(result, const Result<void>.success(null));
      verify(() => mockRepository.deleteReminder(tId)).called(1);
      // It cancels daily (0) and 7 weekly days (1-7)
      verify(() => mockScheduler.cancel(any())).called(greaterThanOrEqualTo(1));
    });

    test('should return Failure and NOT cancel notifications when DB deletion fails', () async {
      // Arrange
      when(() => mockRepository.deleteReminder(tId))
          .thenAnswer((_) async => const Result.failure(CacheFailure(message: 'DB Error')));

      // Act
      final result = await useCase(tId);

      // Assert
      expect(result, const Result<void>.failure(CacheFailure(message: 'DB Error')));
      verify(() => mockRepository.deleteReminder(tId)).called(1);
      verifyNever(() => mockScheduler.cancel(any()));
    });
  });
}
