import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';

abstract interface class ReadingSettingsRepository {
  // Loads settings
  Future<Result<ReadingSettingsEntity>> getReadingSettings();

  // Saves settings
  Future<Result<void>> updateReadingSettings(ReadingSettingsEntity settings);
}
