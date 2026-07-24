import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';

class GetReadingSettingsUseCase {
  const GetReadingSettingsUseCase(this._repository);

  final ReadingSettingsRepository _repository;

  Future<Result<ReadingSettings>> call() {
    return _repository.getReadingSettings();
  }
}
