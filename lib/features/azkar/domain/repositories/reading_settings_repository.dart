import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';

abstract interface class ReadingSettingsRepository {
  // Reads reading settings
  Future<Result<ReadingSettingsEntity>> getReadingSettings();

  // Saves reading settings
  Future<Result<void>> updateReadingSettings(ReadingSettingsEntity settings);
}
