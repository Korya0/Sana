import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';

abstract interface class ReadingSettingsRepository {
  Future<Result<ReadingSettings>> getReadingSettings();
  Future<Result<void>> updateReadingSettings(ReadingSettings settings);
}
