import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';

abstract class IQiblaLocalDataSource {
  double? getLatitude();
  double? getLongitude();
  bool hasStoredLocation();
}

class QiblaLocalDataSource implements IQiblaLocalDataSource {
  QiblaLocalDataSource(this._sharedPref);
  final ILocalStorageService _sharedPref;

  @override
  double? getLatitude() => _sharedPref.getDouble(StorageKeys.latitude);
  @override
  double? getLongitude() => _sharedPref.getDouble(StorageKeys.longitude);

  @override
  bool hasStoredLocation() {
    return getLatitude() != null && getLongitude() != null;
  }
}
