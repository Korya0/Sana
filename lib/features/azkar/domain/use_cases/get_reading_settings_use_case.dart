import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';

class GetReadingSettingsUseCase {
  // Creates use case
  GetReadingSettingsUseCase(this._repository);

  final ReadingSettingsRepository _repository;

  // Loads settings
  Future<Result<ReadingSettingsEntity>> call() =>
      _repository.getReadingSettings();
}
