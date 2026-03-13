import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';

class QiblaLocalDataSource {
  QiblaLocalDataSource(this._sharedPref);
  final ILocalStorageService _sharedPref;

  double? getLatitude() => _sharedPref.getDouble(StorageKeys.latitude);
  double? getLongitude() => _sharedPref.getDouble(StorageKeys.longitude);

  bool hasStoredLocation() {
    return getLatitude() != null && getLongitude() != null;
  }
}
