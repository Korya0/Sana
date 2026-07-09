import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';

class ReadingSettingsRepositoryImpl implements IReadingSettingsRepository {
  ReadingSettingsRepositoryImpl(this._localStorageService);

  final ILocalStorageService _localStorageService;

  @override
  Future<Result<ReadingSettings>> getReadingSettings() async {
    try {
      final fontSize = _localStorageService.getDouble(
            AzkarConstants.keyFontSize,
          ) ??
          AzkarConstants.defaultFontSize;

      return Result.success(
        ReadingSettings(
          fontSize: fontSize,
        ),
      );
    } on Object catch (e, stackTrace) {
      await AppLogger.error(
        'Failed to retrieve reading settings from local storage',
        error: e,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: 'Failed to retrieve reading settings'),
      );
    }
  }

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettings settings,
  ) async {
    try {
      await _localStorageService.setDouble(
        AzkarConstants.keyFontSize,
        settings.fontSize,
      );
      return const Result.success(null);
    } on Object catch (e, stackTrace) {
      await AppLogger.error(
        'Failed to update reading settings in local storage',
        error: e,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: 'Failed to update reading settings'),
      );
    }
  }
}
