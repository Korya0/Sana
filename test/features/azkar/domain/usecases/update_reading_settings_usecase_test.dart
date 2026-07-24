import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_usecase.dart';

class MockReadingSettingsRepository extends Mock implements ReadingSettingsRepository {}

void main() {
  late UpdateReadingSettingsUseCase useCase;
  late MockReadingSettingsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const ReadingSettings(fontSize: 20));
  });

  setUp(() {
    mockRepository = MockReadingSettingsRepository();
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
