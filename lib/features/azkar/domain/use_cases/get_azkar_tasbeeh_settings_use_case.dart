import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';

class GetAzkarTasbeehSettingsUseCase {
  // Creates use case
  GetAzkarTasbeehSettingsUseCase(this._repository);

  final AzkarTasbeehSettingsRepository _repository;

  // Loads settings
  Future<Result<AzkarTasbeehSettingsEntity>> call() =>
      _repository.getAzkarTasbeehSettings();
}
