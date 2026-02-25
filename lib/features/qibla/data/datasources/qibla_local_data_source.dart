import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';

class QiblaLocalDataSource {
  QiblaLocalDataSource(this._sharedPref);
  final SharedPref _sharedPref;

  double? getLatitude() => _sharedPref.getDouble(PrefKeys.latitude);
  double? getLongitude() => _sharedPref.getDouble(PrefKeys.longitude);

  bool hasStoredLocation() {
    return getLatitude() != null && getLongitude() != null;
  }
}
