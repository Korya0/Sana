import 'package:geolocator/geolocator.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';

abstract class ILocationLocalDataSource {
  Future<bool> isLocationEnabled();
  Future<bool> hasPermission();
  Future<LocationPermission> getPermission();
  Future<LocationPermission> requestPermission();
  Future<bool> openLocationSettings();
  Future<bool> openAppSettings();
  Future<Position> getCurrentPosition();
}

class LocationLocalDataSourceImpl implements ILocationLocalDataSource {
  LocationLocalDataSourceImpl(this._permissionsManager);

  final IAppPermissionsManager _permissionsManager;

  @override
  Future<bool> isLocationEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<bool> hasPermission() async {
    return _permissionsManager.isLocationGranted();
  }

  @override
  Future<LocationPermission> getPermission() async {
    return Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  @override
  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  @override
  Future<bool> openAppSettings() async {
    return _permissionsManager.openSettings();
  }

  @override
  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
