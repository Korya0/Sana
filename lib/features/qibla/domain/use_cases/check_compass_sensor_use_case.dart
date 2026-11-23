import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class CheckCompassSensorUseCase {
  CheckCompassSensorUseCase(this._repository);

  final QiblaRepository _repository;

  // Sensor availability
  Future<Result<bool>> call() => _repository.hasCompassSensor();
}
