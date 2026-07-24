import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/usecases/get_reading_settings_usecase.dart';

class MockIReadingSettingsRepository extends Mock implements IReadingSettingsRepository {}

void main() {
  late GetReadingSettingsUseCase useCase;
  late MockIReadingSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockIReadingSettingsRepository();
    useCase = GetReadingSettingsUseCase(mockRepository);
  });

  test('call() should invoke repository.getReadingSettings() and return the result', () async {
    const settings = ReadingSettings(fontSize: 16);
    when(() => mockRepository.getReadingSettings()).thenAnswer(
      (_) async => const Result.success(settings),
    );

    final result = await useCase.call();

    expect(result, isA<Success<ReadingSettings>>());
    expect((result as Success).data, settings);
    verify(() => mockRepository.getReadingSettings()).called(1);
  });
}
