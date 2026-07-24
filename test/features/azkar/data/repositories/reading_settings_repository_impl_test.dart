import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/repositories/reading_settings_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';

class MockILocalStorageService extends Mock implements ILocalStorageService {}

void main() {
  late ReadingSettingsRepositoryImpl repository;
  late MockILocalStorageService mockStorage;

  setUp(() {
    mockStorage = MockILocalStorageService();
    repository = ReadingSettingsRepositoryImpl(mockStorage);
  });

  group('getReadingSettings()', () {
    test('should return Result.success with saved ReadingSettings', () async {
      when(() => mockStorage.getDouble(AzkarConstants.keyFontSize)).thenReturn(16);

      final result = await repository.getReadingSettings();

      expect(result, isA<Success<ReadingSettings>>());
      final data = (result as Success<ReadingSettings>).data;
      expect(data.fontSize, 16);
    });

    test('should return defaultFontSize when no saved value exists', () async {
      when(() => mockStorage.getDouble(AzkarConstants.keyFontSize)).thenReturn(null);

      final result = await repository.getReadingSettings();

      expect(result, isA<Success<ReadingSettings>>());
      final data = (result as Success<ReadingSettings>).data;
      expect(data.fontSize, AzkarConstants.defaultFontSize);
    });

    test('should return Result.failure(CacheFailure) on exception', () async {
      when(() => mockStorage.getDouble(any()))
          .thenThrow(Exception('Storage error'));

      final result = await repository.getReadingSettings();

      expect(result, isA<FailureResult<ReadingSettings>>());
      expect((result as FailureResult).failure, isA<CacheFailure>());
    });
  });

  group('updateReadingSettings()', () {
    test('should save fontSize in local storage', () async {
      when(() => mockStorage.setDouble(any(), any())).thenAnswer((_) async {});
      const settings = ReadingSettings(fontSize: 18);

      final result = await repository.updateReadingSettings(settings);

      expect(result, isA<Success<void>>());
      verify(() => mockStorage.setDouble(AzkarConstants.keyFontSize, 18)).called(1);
    });

    test('should return Result.success(null) on success', () async {
      when(() => mockStorage.setDouble(any(), any())).thenAnswer((_) async {});
      const settings = ReadingSettings(fontSize: 20);

      final result = await repository.updateReadingSettings(settings);

      expect(result, isA<Success<void>>());
    });

    test('should return Result.failure(CacheFailure) on exception', () async {
      when(() => mockStorage.setDouble(any(), any()))
          .thenThrow(Exception('Save error'));
      const settings = ReadingSettings(fontSize: 18);

      final result = await repository.updateReadingSettings(settings);

      expect(result, isA<FailureResult<void>>());
      expect((result as FailureResult).failure, isA<CacheFailure>());
    });
  });
}
