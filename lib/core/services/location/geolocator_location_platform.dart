import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/location/location_platform.dart';
import 'package:sana/core/services/location/location_result.dart';

class GeolocatorLocationPlatform implements LocationPlatform {
  const GeolocatorLocationPlatform();

  // Permission status
  @override
  Future<bool> hasPermission() async => (await ph.Permission.location.status).isGranted;

  // Requests permission
  @override
  Future<bool> requestPermission() async =>
      (await ph.Permission.location.request()).isGranted;

  // Current position
  @override
  Future<LocationResult> getCurrentPosition() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      throw const LocationFailure(message: AppStrings.qiblaFailedTitle);
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: AppConstants.qiblaLocationTimeout12s,
      ),
    );
    return _toResult(position);
  }

  // Position stream
  @override
  Stream<LocationResult> watchPosition() => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: AppConstants.qiblaLocationDistanceFilter10m,
        ),
      ).map(_toResult);

  // App settings
  @override
  Future<void> openAppSettings() => ph.openAppSettings();

  // Location settings
  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  // Mapping
  LocationResult _toResult(Position position) => LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        heading: position.heading,
        takenAt: position.timestamp,
      );
}
