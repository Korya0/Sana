import 'package:geolocator/geolocator.dart';

class LocationLocalDataSource {
  /// 1) هل الـ GPS (Location) مفعّل على الجهاز؟
  Future<bool> isLocationEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// 2) هل التطبيق معه إذن استخدام الموقع؟
  Future<bool> hasPermission() async {
    final status = await Geolocator.checkPermission();
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
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
    return Geolocator.openAppSettings();
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
