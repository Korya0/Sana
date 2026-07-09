import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/usecases/update_reading_settings_usecase.dart';

class MockReadingSettingsRepository extends Mock
    implements IReadingSettingsRepository {}

class FakeReadingSettings extends Fake implements ReadingSettings {}

void main() {
  late UpdateReadingSettingsUseCase useCase;
  late MockReadingSettingsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeReadingSettings());
  });

  setUp(() {
    mockRepository = MockReadingSettingsRepository();
    useCase = UpdateReadingSettingsUseCase(mockRepository);
  });

  const tSettings = ReadingSettings(fontSize: 24);
  const tFailure = CacheFailure(message: 'Failed to update reading settings');

  test('should forward ReadingSettings to the repository for update', () async {
    // arrange
    when(() => mockRepository.updateReadingSettings(any()))
        .thenAnswer((_) async => const Result.success(null));

    // act
    final result = await useCase(tSettings);

    // assert
    expect(result, isA<Success<void>>());
    verify(() => mockRepository.updateReadingSettings(tSettings)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure from the repository when updating fails', () async {
    // arrange
    when(() => mockRepository.updateReadingSettings(any()))
        .thenAnswer((_) async => const Result.failure(tFailure));

    // act
    final result = await useCase(tSettings);

    // assert
    expect(result, const Result<void>.failure(tFailure));
    verify(() => mockRepository.updateReadingSettings(tSettings)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
