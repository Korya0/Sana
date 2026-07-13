import 'package:sana/core/networking/result.dart';

enum AppLocationPermission {
  denied,
  deniedForever,
  whileInUse,
  always,
  unableToDetermine,
}

abstract interface class ILocationRepository {
  Future<Result<bool>> isLocationEnabled();

  Future<Result<void>> openLocationSettings();
  Future<Result<bool>> hasPermission();

  Future<Result<AppLocationPermission>> requestPermission();

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

  Future<Result<AppLocationPermission>> getPermissionStatus();

  bool hasStoredLocation();

  String? getStoredLocationName();
}
