import 'package:sana/core/services/location/location_result.dart';

abstract interface class LocationPlatform {
  // Permission status
  Future<bool> hasPermission();

  // Requests permission
  Future<bool> requestPermission();

  // Current position
  Future<LocationResult> getCurrentPosition();

  // Position stream
  Stream<LocationResult> watchPosition();

  // App settings
  Future<void> openAppSettings();

  // Location settings
  Future<void> openLocationSettings();
}
