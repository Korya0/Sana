import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class OpenLocationSettingsUseCase {
  OpenLocationSettingsUseCase(this._repository);

  final QiblaRepository _repository;

  // Opens location settings
  Future<Result<void>> call() => _repository.openLocationSettings();
}
