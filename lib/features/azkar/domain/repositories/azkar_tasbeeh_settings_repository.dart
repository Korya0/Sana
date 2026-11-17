import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';

abstract interface class AzkarTasbeehSettingsRepository {
  // Loads settings
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings();

  // Saves settings
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  );
}
