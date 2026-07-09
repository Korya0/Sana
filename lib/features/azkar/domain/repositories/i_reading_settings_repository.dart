import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';

abstract interface class IReadingSettingsRepository {
  Future<Result<ReadingSettings>> getReadingSettings();
  Future<Result<void>> updateReadingSettings(ReadingSettings settings);
}
