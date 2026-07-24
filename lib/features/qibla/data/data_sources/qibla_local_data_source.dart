import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/foundation.dart';

abstract interface class QiblaLocalDataSource {
  double? getLatitude();
  double? getLongitude();
  bool hasStoredLocation();
  String? getQiblaMode();
  Future<void> saveQiblaMode(String mode);
  Stream<double?>? getCompassStream();
}

class QiblaLocalDataSourceImpl implements QiblaLocalDataSource {
  QiblaLocalDataSourceImpl(this._sharedPref);
  final LocalStorageService _sharedPref;

  @override
  double? getLatitude() => _sharedPref.getDouble(StorageKeys.latitude);
  @override
  double? getLongitude() => _sharedPref.getDouble(StorageKeys.longitude);

  @override
  bool hasStoredLocation() {
    return getLatitude() != null && getLongitude() != null;
  }

  @override
  String? getQiblaMode() => _sharedPref.getString(StorageKeys.qiblaMode);

  @override
  Future<void> saveQiblaMode(String mode) =>
      _sharedPref.setString(StorageKeys.qiblaMode, mode);

  @override
  Stream<double?>? getCompassStream() {
    if (kIsWeb) return null;
    return FlutterCompass.events?.map((e) => e.heading);
  }
}
