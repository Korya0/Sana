import 'package:geolocator/geolocator.dart';
import 'package:sana/core/networking/api_result.dart';

abstract class ILocationRepository {
  Future<ApiResult<bool>> isLocationEnabled();

  Future<ApiResult<void>> openLocationSettings();
  Future<ApiResult<bool>> hasPermission();

  Future<ApiResult<LocationPermission>> requestPermission();

  Future<ApiResult<bool>> saveCurrentPosition();

  Future<ApiResult<void>> saveManualPosition({
    required double lat,
    required double lng,
    required String name,
  });

  Future<ApiResult<String>> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  });

  Future<ApiResult<LocationPermission>> getPermissionStatus();

  bool hasStoredLocation();

  String? getStoredLocationName();
}
