import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';

class QiblaRepository {

  QiblaRepository({required SharedPref sharedPref}) : _sharedPref = sharedPref;
  final SharedPref _sharedPref;

  Map<String, double> getUserLocation() {
    final lat = _sharedPref.getDouble(PrefKeys.latitude);
    final lng = _sharedPref.getDouble(PrefKeys.longitude);

    return {'lat': lat!, 'lng': lng!};
  }

  double calculateQiblaDirection(double lat, double lng) {
    return QiblaService.calculateQiblaDirection(lat, lng);
  }

  double calculateDistanceToKaaba(double lat, double lng) {
    return QiblaService.calculateDistance(
      lat,
      lng,
      QiblaConstants.kaabaLatitude,
      QiblaConstants.kaabaLongitude,
    );
  }
}
