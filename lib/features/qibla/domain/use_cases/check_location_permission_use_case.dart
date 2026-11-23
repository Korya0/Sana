import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class CheckLocationPermissionUseCase {
  CheckLocationPermissionUseCase(this._repository);

  final QiblaRepository _repository;

  // Permission status
  Future<Result<bool>> call() => _repository.checkLocationPermission();
}
