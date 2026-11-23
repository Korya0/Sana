import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class OpenAppSettingsUseCase {
  OpenAppSettingsUseCase(this._repository);

  final QiblaRepository _repository;

  // Opens app settings
  Future<Result<void>> call() => _repository.openAppSettings();
}
