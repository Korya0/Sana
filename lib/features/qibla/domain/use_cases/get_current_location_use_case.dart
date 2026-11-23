import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class GetCurrentLocationUseCase {
  GetCurrentLocationUseCase(this._repository);

  final QiblaRepository _repository;

  // Current location
  Future<Result<LocationModel>> call() => _repository.getCurrentLocation();
}
