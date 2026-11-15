import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';

class ReadingSettingsRepositoryImpl implements ReadingSettingsRepository {
  // Creates repository
  ReadingSettingsRepositoryImpl(this._storage, this._logger);

  final AppKeyValueStore _storage;
  final AppLogger _logger;

  // Loads settings
  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async {
    try {
      final savedFontSize = _storage.read<double>(AppStorageKeys.azkarFontSize);
      final savedHaptic = _storage.read<bool>(
        AppStorageKeys.azkarHapticFeedback,
      );

      return Result.success(
        ReadingSettingsEntity(
          fontSize: savedFontSize ?? ReadingSettingsEntity.defaultFontSize,
          hapticFeedbackEnabled:
              savedHaptic ?? ReadingSettingsEntity.defaultHapticFeedbackEnabled,
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.error(
        'ReadingSettings: read failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.loadSettingsError),
      );
    }
  }

  // Saves settings
  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async {
    try {
      await _storage.write(
        AppStorageKeys.azkarFontSize,
        settings.fontSize,
      );
      await _storage.write(
        AppStorageKeys.azkarHapticFeedback,
        settings.hapticFeedbackEnabled,
      );
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'ReadingSettings: write failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.saveSettingsError),
      );
    }
  }
}
