import 'dart:math' as math;

import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/location_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class QiblaRepositoryImpl implements QiblaRepository {
  QiblaRepositoryImpl(
    this._locationDataSource,
    this._compassDataSource,
    this._logger,
    this._locationService,
  );

  final LocationLocalDataSource _locationDataSource;
  final CompassLocalDataSource _compassDataSource;
  final AppLogger _logger;
  final LocationService _locationService;

  // Qibla direction
  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async {
    try {
      final location = await _locationDataSource.getCurrentLocation();
      final direction = _calculateBearing(
        location.latitude,
        location.longitude,
        AppConstants.qiblaKaabaLatitude,
        AppConstants.qiblaKaabaLongitude,
      );
      final distanceKm = _calculateDistanceKm(
        location.latitude,
        location.longitude,
        AppConstants.qiblaKaabaLatitude,
        AppConstants.qiblaKaabaLongitude,
      );

      return Result.success(
        QiblaEntity(
          direction: direction,
          distanceKm: distanceKm,
          location: QiblaLocation(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
          phoneHeading: location.heading,
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.error(
        'QiblaRepository: calculateQiblaDirection failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.qiblaFailedTitle),
      );
    }
  }

  // Current location
  @override
  Future<Result<LocationModel>> getCurrentLocation() async {
    try {
      final location = await _locationDataSource.getCurrentLocation();
      return Result.success(location);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'QiblaRepository: getCurrentLocation failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        LocationFailure(message: AppStrings.qiblaFailedTitle),
      );
    }
  }

  // Sensor availability
  @override
  Future<Result<bool>> hasCompassSensor() async {
    try {
      final hasSensor = await _compassDataSource.hasCompassSensor();
      return Result.success(hasSensor);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'QiblaRepository: hasCompassSensor failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        SensorFailure(message: AppStrings.qiblaUnsupportedMessage),
      );
    }
  }

  // Permission status
  @override
  Future<Result<bool>> checkLocationPermission() =>
      _locationService.checkPermission();

  // Requests permission
  @override
  Future<Result<bool>> requestLocationPermission() =>
      _locationService.requestPermission();

  // Compass stream
  @override
  Stream<CompassSensorData> getCompassStream() =>
      _compassDataSource.onCompassChanged();

  // Location stream
  @override
  Stream<LocationModel> getLocationStream() =>
      _locationDataSource.onLocationChanged();

  // App settings
  @override
  Future<Result<void>> openAppSettings() => _locationService.openAppSettings();

  // Location settings
  @override
  Future<Result<void>> openLocationSettings() =>
      _locationService.openLocationSettings();

  // Great-circle bearing
  double _calculateBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final lat1Rad = lat1 * math.pi / 180;
    final lat2Rad = lat2 * math.pi / 180;
    final deltaLonRad = (lon2 - lon1) * math.pi / 180;

    final y = math.sin(deltaLonRad) * math.cos(lat2Rad);
    final x =
        math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(deltaLonRad);

    final bearing = math.atan2(y, x) * 180 / math.pi;
    return ((bearing % 360) + 360) % 360;
  }

  // Distance in km
  double _calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final lat1Rad = lat1 * math.pi / 180;
    final lat2Rad = lat2 * math.pi / 180;
    final deltaLatRad = (lat2 - lat1) * math.pi / 180;
    final deltaLonRad = (lon2 - lon1) * math.pi / 180;

    final a =
        math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLonRad / 2) *
            math.sin(deltaLonRad / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return AppConstants.earthRadiusKm * c;
  }
}
