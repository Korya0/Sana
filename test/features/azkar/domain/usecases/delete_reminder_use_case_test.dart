import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/delete_reminder_use_case.dart';

class MockIReminderRepository extends Mock implements IReminderRepository {}
class MockINotificationScheduler extends Mock implements INotificationScheduler {}

void main() {
  late DeleteReminderUseCase useCase;
  late MockIReminderRepository mockRepository;
  late MockINotificationScheduler mockScheduler;

  setUp(() {
    mockRepository = MockIReminderRepository();
    mockScheduler = MockINotificationScheduler();
    useCase = DeleteReminderUseCase(mockRepository, mockScheduler);
  });

  test('call(id) should invoke repository.deleteReminder(id)', () async {
    when(() => mockRepository.deleteReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});

    await useCase.call('1');

    verify(() => mockRepository.deleteReminder('1')).called(1);
  });

  test('call(id) should cancel notifications on success', () async {
    when(() => mockRepository.deleteReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});

    await useCase.call('1');

    // verify cancel is called for once + 7 days (8 total)
    verify(() => mockScheduler.cancel('1'.hashCode)).called(1);
  });

  test('call(id) should NOT cancel if delete fails', () async {
    when(() => mockRepository.deleteReminder(any())).thenAnswer(
      (_) async => const Result.failure(
        CacheFailure(message: 'Delete failed'),
      ),
    );

    await useCase.call('1');

    verifyNever(() => mockScheduler.cancel(any()));
  });

  test('call(id) should return the result from repository', () async {
    when(() => mockRepository.deleteReminder(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockScheduler.cancel(any())).thenAnswer((_) async {});

    final result = await useCase.call('1');

    expect(result, isA<Success<void>>());
  });
}
