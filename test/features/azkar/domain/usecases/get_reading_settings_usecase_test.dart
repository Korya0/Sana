import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_usecase.dart';

class MockReadingSettingsRepository extends Mock implements ReadingSettingsRepository {}

void main() {
  late GetReadingSettingsUseCase useCase;
  late MockReadingSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockReadingSettingsRepository();
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
