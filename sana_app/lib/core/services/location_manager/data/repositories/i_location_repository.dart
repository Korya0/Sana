import 'package:geolocator/geolocator.dart';
import 'package:sana/core/networking/api_result.dart';

abstract class ILocationRepository {
  /// تحقق إذا كان GPS مفعّل
  Future<ApiResult<bool>> isLocationEnabled();

  /// طلب فتح إعدادات الـ GPS
  Future<ApiResult<void>> openLocationSettings();

  /// تحقق من إذن الموقع
  Future<ApiResult<bool>> hasPermission();

  /// طلب إذن الموقع
  Future<ApiResult<LocationPermission>> requestPermission();

  /// جلب الموقع وحفظه في SharedPref
  Future<ApiResult<bool>> saveCurrentPosition();

  /// حفظ موقع يدوي في SharedPref
  Future<ApiResult<void>> saveManualPosition({
    required double lat,
    required double lng,
    required String name,
  });

  /// جلب اسم المدينة والدولة
  Future<ApiResult<String>> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  });

  /// جلب حالة إذن الموقع الحالية
  Future<ApiResult<LocationPermission>> getPermissionStatus();

  /// التحقق من وجود موقع مخزن مسبقاً
  bool hasStoredLocation();

  /// جلب اسم الموقع المخزن
  String? getStoredLocationName();
}
