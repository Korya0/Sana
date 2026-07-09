import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/data/models/reading_settings_model.dart';

abstract interface class IReadingSettingsRepository {
  Future<Result<ReadingSettingsModel>> getReadingSettings();
  Future<Result<void>> updateReadingSettings(ReadingSettingsModel settings);
}
