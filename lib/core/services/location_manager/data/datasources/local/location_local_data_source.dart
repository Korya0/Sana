import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/services/location_manager/data/datasources/local/geolocator_wrapper.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';

abstract class ILocationLocalDataSource {
  Future<bool> isLocationEnabled();
  Future<bool> hasPermission();
  Future<LocationPermission> checkPermissionStatus();
  Future<LocationPermission> requestPermission();
  Future<bool> openLocationSettings();
  Future<bool> openAppSettings();
  Future<Position> getCurrentPosition();
  Future<Position?> getLastKnownPosition();
}

class LocationLocalDataSource implements ILocationLocalDataSource {
  LocationLocalDataSource(this._permissionsManager, this._geolocator);

  final IAppPermissionsManager _permissionsManager;
  final IGeolocatorWrapper _geolocator;

  @override
  Future<bool> isLocationEnabled() async {
    return _geolocator.isLocationServiceEnabled();
  }

  @override
  Future<bool> hasPermission() async {
    return _permissionsManager.isLocationGranted();
  }

  @override
  Future<LocationPermission> checkPermissionStatus() async {
    return _geolocator.checkPermissionStatus();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return _geolocator.requestPermission();
  }

  @override
  Future<bool> openLocationSettings() async {
    if (kIsWeb) return false;
    return _geolocator.openLocationSettings();
  }

  @override
  Future<bool> openAppSettings() async {
    return _permissionsManager.openSettings();
  }

  @override
  Future<Position> getCurrentPosition() async {
    return _geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  @override
  Future<Position?> getLastKnownPosition() async {
    if (kIsWeb) return null;
    return _geolocator.getLastKnownPosition();
  }
}
