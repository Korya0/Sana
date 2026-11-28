import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/location_result.dart';

abstract interface class LocationService {
  // Permission status
  Future<Result<bool>> checkPermission();

  // Requests permission
  Future<Result<bool>> requestPermission();

  // Current location
  Future<Result<LocationResult>> getCurrentLocation();

  // Location stream
  Stream<LocationResult> watchLocation();

  // App settings
  Future<Result<void>> openAppSettings();

  // Location settings
  Future<Result<void>> openLocationSettings();
}
