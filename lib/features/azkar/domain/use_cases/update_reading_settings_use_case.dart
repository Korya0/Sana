import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';

class UpdateReadingSettingsUseCase {
  UpdateReadingSettingsUseCase(this._repository);

  final ReadingSettingsRepository _repository;

  // Saves reading settings
  Future<Result<void>> call(ReadingSettingsEntity settings) =>
      _repository.updateReadingSettings(settings);
}
