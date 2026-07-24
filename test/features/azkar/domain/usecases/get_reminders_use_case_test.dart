import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/get_reminders_use_case.dart';

class MockIReminderRepository extends Mock implements IReminderRepository {}

void main() {
  late GetRemindersUseCase useCase;
  late MockIReminderRepository mockRepository;

  setUp(() {
    mockRepository = MockIReminderRepository();
    useCase = GetRemindersUseCase(mockRepository);
  });

  test('call(azkarId) should invoke repository.getReminders(azkarId)', () async {
    when(() => mockRepository.getReminders(any())).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );

    final result = await useCase.call('2');

    expect(result, isA<Success<List<ReminderEntity>>>());
    verify(() => mockRepository.getReminders('2')).called(1);
  });
}
