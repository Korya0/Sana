import 'package:geolocator/geolocator.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';

class LocationLocalDataSource {
  LocationLocalDataSource(this._permissionsManager);

  final IAppPermissionsManager _permissionsManager;
  /// 1) هل الـ GPS (Location) مفعّل على الجهاز؟
  Future<bool> isLocationEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// 2) هل التطبيق معه إذن استخدام الموقع؟
  Future<bool> hasPermission() async {
    return _permissionsManager.isLocationGranted();
  }

  /// اطلب حالة إذن الموقع الحالية
  Future<LocationPermission> getPermission() async {
    return Geolocator.checkPermission();
  }

  /// 3) اطلب إذن الموقع من المستخدم
  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  /// 4) افتح إعدادات الجهاز لتمكين الموقع
  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  /// 5) افتح إعدادات إذن التطبيق نفسه
  Future<bool> openAppSettings() async {
    return _permissionsManager.openSettings();
  }

  /// 6) إرجاع إحداثيات الموقع (Latitude & Longitude)
  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
