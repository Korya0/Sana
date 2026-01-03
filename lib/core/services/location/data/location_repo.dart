import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/location/data/location_service.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';

abstract class LocationRepo {
  /// تحقق إذا كان GPS مفعّل
  Future<bool> isLocationEnabled();

  /// طلب فتح إعدادات الـ GPS
  Future<void> openLocationSettings();

  /// تحقق من إذن الموقع
  Future<bool> hasPermission();

  /// طلب إذن الموقع
  Future<LocationPermission> requestPermission();

  /// جلب الموقع وحفظه في SharedPref
  Future<Either<LocationFailure, bool>> saveCurrentPosition();

  /// التحقق من وجود موقع مخزن مسبقاً
  bool hasStoredLocation();
}

class LocationRepoImpl implements LocationRepo {
  final LocationService locationService;
  final SharedPref sharedPref;

  LocationRepoImpl({required this.locationService, required this.sharedPref});

  @override
  Future<bool> isLocationEnabled() => locationService.isLocationEnabled();

  @override
  Future<void> openLocationSettings() => locationService.openLocationSettings();

  @override
  Future<bool> hasPermission() => locationService.hasPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      locationService.requestPermission();

  @override
  Future<Either<LocationFailure, bool>> saveCurrentPosition() async {
    try {
      final position = await locationService.getCurrentPosition();
      sharedPref.setDouble(PrefKeys.latitude, position.latitude);
      sharedPref.setDouble(PrefKeys.longitude, position.longitude);
      return right(true);
    } catch (e) {
      return left(
        LocationFailure(
          message: 'حدث خطأ أثناء الحصول على الموقع: ${e.toString()}',
        ),
      );
    }
  }

  @override
  bool hasStoredLocation() {
    return sharedPref.getDouble(PrefKeys.latitude) != null &&
        sharedPref.getDouble(PrefKeys.longitude) != null;
  }
}
