import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/get_reminders_use_case.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

void main() {
  late GetRemindersUseCase useCase;
  late MockReminderRepository mockRepository;

  setUp(() {
    mockRepository = MockReminderRepository();
    useCase = GetRemindersUseCase(mockRepository);
  });

  const tAzkarId = '2';
  final tRemindersList = [
    const ReminderEntity(
      id: '123',
      azkarId: '2',
      time: '07:00',
      repeatType: RepeatType.daily,
      days: [],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    )
  ];

  group('GetRemindersUseCase', () {
    test('should return list of reminders from repository when successful', () async {
      // Arrange
      when(() => mockRepository.getReminders(tAzkarId))
          .thenAnswer((_) async => Result.success(tRemindersList));

      // Act
      final result = await useCase(tAzkarId);

      // Assert
      expect(result, Result<List<ReminderEntity>>.success(tRemindersList));
      verify(() => mockRepository.getReminders(tAzkarId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getReminders(tAzkarId))
          .thenAnswer((_) async => const Result.failure(CacheFailure(message: 'Error')));

      // Act
      final result = await useCase(tAzkarId);

      // Assert
      expect(result, const Result<List<ReminderEntity>>.failure(CacheFailure(message: 'Error')));
      verify(() => mockRepository.getReminders(tAzkarId)).called(1);
    });
  });
}
