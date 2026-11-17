import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/local_storage/app_key_value_store.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';

class AzkarTasbeehSettingsRepositoryImpl
    implements AzkarTasbeehSettingsRepository {
  // Creates repository
  AzkarTasbeehSettingsRepositoryImpl(this._storage, this._logger);

  final AppKeyValueStore _storage;
  final AppLogger _logger;

  // Loads settings
  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async {
    try {
      final savedFontSize = _storage.read<double>(
        AppStorageKeys.readingFontSize,
      );
      final savedHaptic = _storage.read<bool>(
        AppStorageKeys.readingHapticFeedback,
      );

      return Result.success(
        AzkarTasbeehSettingsEntity(
          fontSize: savedFontSize ?? AzkarTasbeehSettingsEntity.defaultFontSize,
          hapticFeedbackEnabled:
              savedHaptic ??
              AzkarTasbeehSettingsEntity.defaultHapticFeedbackEnabled,
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.error(
        'AzkarTasbeehSettings: read failed',
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
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async {
    try {
      await _storage.write(
        AppStorageKeys.readingFontSize,
        settings.fontSize,
      );
      await _storage.write(
        AppStorageKeys.readingHapticFeedback,
        settings.hapticFeedbackEnabled,
      );
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'AzkarTasbeehSettings: write failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.saveSettingsError),
      );
    }
  }
}
