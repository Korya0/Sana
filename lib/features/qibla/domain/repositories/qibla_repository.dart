import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';

abstract interface class QiblaRepository {
  // Sensor availability
  Future<Result<bool>> hasCompassSensor();

  // Permission status
  Future<Result<bool>> checkLocationPermission();

  // Requests permission
  Future<Result<bool>> requestLocationPermission();

  // Current location
  Future<Result<LocationModel>> getCurrentLocation();

  // Qibla direction
  Future<Result<QiblaEntity>> calculateQiblaDirection();

  // Compass stream
  Stream<CompassSensorData> getCompassStream();

  // Location stream
  Stream<LocationModel> getLocationStream();

  // App settings
  Future<Result<void>> openAppSettings();

  // Location settings
  Future<Result<void>> openLocationSettings();
}
