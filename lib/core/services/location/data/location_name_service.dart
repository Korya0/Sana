import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationNameService {
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';

  /// Reads lat/lng from SharedPreferences and returns city + country
  static Future<String?> getCityAndCountry() async {
    final prefs = await SharedPreferences.getInstance();

    final double? lat = prefs.getDouble(_latitudeKey);
    final double? lng = prefs.getDouble(_longitudeKey);

    if (lat == null || lng == null) return null;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) return null;

      final Placemark place = placemarks.first;

      final String city = place.locality ?? place.subAdministrativeArea ?? '';
      final String country = place.country ?? '';

      return '$city, $country';
    } catch (e) {
      return null;
    }
  }
}
