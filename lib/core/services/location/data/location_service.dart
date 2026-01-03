// ignore_for_file: deprecated_member_use

import 'package:geolocator/geolocator.dart';

class LocationService {
  /// 1) هل الـ GPS (Location) مفعّل على الجهاز؟
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// 2) هل التطبيق معه إذن استخدام الموقع؟
  Future<bool> hasPermission() async {
    final status = await Geolocator.checkPermission();
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  /// 3) اطلب إذن الموقع من المستخدم
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// 4) افتح إعدادات الجهاز لتمكين الموقع
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// 5) افتح إعدادات إذن التطبيق نفسه
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// 6) إرجاع إحداثيات الموقع (Latitude & Longitude)
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// 7) الحصول على آخر موقع معروف (سريع ولا يحتاج انتظار)
  Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }
}
