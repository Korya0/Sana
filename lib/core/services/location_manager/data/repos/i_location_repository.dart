import 'package:geolocator/geolocator.dart';
import 'package:sana/core/networking/result.dart';

abstract class ILocationRepository {
  Future<Result<bool>> isLocationEnabled();

  Future<Result<void>> openLocationSettings();
  Future<Result<bool>> hasPermission();

  Future<Result<LocationPermission>> requestPermission();

  Future<Result<bool>> saveCurrentPosition();

  Future<Result<void>> saveManualPosition({
    required double lat,
    required double lng,
    required String name,
  });

  Future<Result<String>> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  });

  Future<Result<LocationPermission>> getPermissionStatus();

  bool hasStoredLocation();

  String? getStoredLocationName();
}
