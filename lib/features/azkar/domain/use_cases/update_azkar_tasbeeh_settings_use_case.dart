import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';

class UpdateAzkarTasbeehSettingsUseCase {
  // Creates use case
  UpdateAzkarTasbeehSettingsUseCase(this._repository);

  final AzkarTasbeehSettingsRepository _repository;

  // Saves settings
  Future<Result<void>> call(AzkarTasbeehSettingsEntity settings) =>
      _repository.updateAzkarTasbeehSettings(settings);
}
