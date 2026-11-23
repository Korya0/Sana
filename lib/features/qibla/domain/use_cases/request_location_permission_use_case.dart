import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class RequestLocationPermissionUseCase {
  RequestLocationPermissionUseCase(this._repository);

  final QiblaRepository _repository;

  // Requests location permission
  Future<Result<bool>> call() => _repository.requestLocationPermission();
}
