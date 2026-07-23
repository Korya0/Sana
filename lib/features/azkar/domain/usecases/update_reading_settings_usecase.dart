import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';

class UpdateReadingSettingsUseCase {
  const UpdateReadingSettingsUseCase(this._repository);

  final IReadingSettingsRepository _repository;

  Future<Result<void>> call(ReadingSettings settings) {
    return _repository.updateReadingSettings(settings);
  }
}
