import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/usecases/get_reading_settings_usecase.dart';

class MockReadingSettingsRepository extends Mock
    implements IReadingSettingsRepository {}

void main() {
  late GetReadingSettingsUseCase useCase;
  late MockReadingSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockReadingSettingsRepository();
    useCase = GetReadingSettingsUseCase(mockRepository);
  });

  const tSettings = ReadingSettings(fontSize: 20);
  const tFailure = CacheFailure(message: 'Failed to retrieve reading settings');

  test('should get ReadingSettings from the repository', () async {
    // arrange
    when(() => mockRepository.getReadingSettings())
        .thenAnswer((_) async => const Result.success(tSettings));

    // act
    final result = await useCase();

    // assert
    expect(result, const Result.success(tSettings));
    verify(() => mockRepository.getReadingSettings()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure from the repository when getting fails', () async {
    // arrange
    when(() => mockRepository.getReadingSettings())
        .thenAnswer((_) async => const Result.failure(tFailure));

    // act
    final result = await useCase();

    // assert
    expect(result, const Result<ReadingSettings>.failure(tFailure));
    verify(() => mockRepository.getReadingSettings()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
