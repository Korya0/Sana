import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class GetCompassStreamUseCase {
  GetCompassStreamUseCase(this._repository);

  final QiblaRepository _repository;

  // Compass stream
  Stream<CompassSensorData> call() => _repository.getCompassStream();
}
