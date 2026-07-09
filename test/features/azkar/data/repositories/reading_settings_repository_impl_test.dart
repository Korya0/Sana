import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/repositories/reading_settings_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';

class MockLocalStorageService extends Mock implements ILocalStorageService {}

void main() {
  late ReadingSettingsRepositoryImpl repository;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() {
    mockLocalStorageService = MockLocalStorageService();
    repository = ReadingSettingsRepositoryImpl(mockLocalStorageService);
  });

  group('getReadingSettings', () {
    const tFontSize = 25.0;
    const tSettings = ReadingSettings(fontSize: tFontSize);
    const tDefaultSettings =
        ReadingSettings(fontSize: AzkarConstants.defaultFontSize);

    test('should return ReadingSettings with saved font size if present',
        () async {
      // arrange
      when(() => mockLocalStorageService.getDouble(AzkarConstants.keyFontSize))
          .thenReturn(tFontSize);

      // act
      final result = await repository.getReadingSettings();

      // assert
      expect(result, const Result.success(tSettings));
      verify(() => mockLocalStorageService.getDouble(AzkarConstants.keyFontSize))
          .called(1);
      verifyNoMoreInteractions(mockLocalStorageService);
    });

    test('should return ReadingSettings with default font size if not present',
        () async {
      // arrange
      when(() => mockLocalStorageService.getDouble(AzkarConstants.keyFontSize))
          .thenReturn(null);

      // act
      final result = await repository.getReadingSettings();

      // assert
      expect(result, const Result.success(tDefaultSettings));
      verify(() => mockLocalStorageService.getDouble(AzkarConstants.keyFontSize))
          .called(1);
      verifyNoMoreInteractions(mockLocalStorageService);
    });

    test('should return CacheFailure when local storage throws an exception',
        () async {
      // arrange
      when(() => mockLocalStorageService.getDouble(AzkarConstants.keyFontSize))
          .thenThrow(Exception());

      // act
      final result = await repository.getReadingSettings();

      // assert
      expect(
        result,
        const Result<ReadingSettings>.failure(
          CacheFailure(message: 'Failed to retrieve reading settings'),
        ),
      );
      verify(() => mockLocalStorageService.getDouble(AzkarConstants.keyFontSize))
          .called(1);
      verifyNoMoreInteractions(mockLocalStorageService);
    });
  });

  group('updateReadingSettings', () {
    const tSettings = ReadingSettings(fontSize: 30);

    test('should save font size to local storage and return success', () async {
      // arrange
      when(
        () => mockLocalStorageService.setDouble(
          AzkarConstants.keyFontSize,
          tSettings.fontSize,
        ),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.updateReadingSettings(tSettings);

      // assert
      expect(result, isA<Success<void>>());
      verify(
        () => mockLocalStorageService.setDouble(
          AzkarConstants.keyFontSize,
          tSettings.fontSize,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockLocalStorageService);
    });

    test('should return CacheFailure when local storage saving fails', () async {
      // arrange
      when(
        () => mockLocalStorageService.setDouble(any(), any()),
      ).thenThrow(Exception());

      // act
      final result = await repository.updateReadingSettings(tSettings);

      // assert
      expect(
        result,
        const Result<void>.failure(
          CacheFailure(message: 'Failed to update reading settings'),
        ),
      );
      verify(
        () => mockLocalStorageService.setDouble(
          AzkarConstants.keyFontSize,
          tSettings.fontSize,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockLocalStorageService);
    });
  });
}
