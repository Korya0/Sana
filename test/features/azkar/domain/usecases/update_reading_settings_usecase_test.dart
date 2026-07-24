import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/usecases/update_reading_settings_usecase.dart';

class MockIReadingSettingsRepository extends Mock implements IReadingSettingsRepository {}

void main() {
  late UpdateReadingSettingsUseCase useCase;
  late MockIReadingSettingsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const ReadingSettings(fontSize: 20));
  });

  setUp(() {
    mockRepository = MockIReadingSettingsRepository();
    useCase = UpdateReadingSettingsUseCase(mockRepository);
  });

  test('call(settings) should invoke repository.updateReadingSettings(settings)', () async {
    const settings = ReadingSettings(fontSize: 20);
    when(() => mockRepository.updateReadingSettings(any())).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCase.call(settings);

    expect(result, isA<Success<void>>());
    verify(() => mockRepository.updateReadingSettings(settings)).called(1);
  });
}
