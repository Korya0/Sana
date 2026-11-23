import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';

abstract interface class CompassLocalDataSource {
  // Sensor availability
  Future<bool> hasCompassSensor();

  // Compass stream
  Stream<CompassSensorData> onCompassChanged();
}
