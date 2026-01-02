import 'package:geocoding/geocoding.dart';
import 'package:sana/core/constants/app_constants.dart';

class LocationNameService {
  Future<String> getCityAndCountry({
    required double lat,
    required double lng,
    required String locale,
  }) async {
    try {
      await setLocaleIdentifier(locale);

      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return AppStrings.unknownLocation;

      final place = placemarks.first;

      final part1 =
          place.locality ??
          place.subAdministrativeArea ??
          place.administrativeArea;
      final part2 = place.country;

      if (part1 != null && part2 != null) {
        return '$part1, $part2';
      } else if (part2 != null) {
        return part2;
      } else {
        return AppStrings.unknownLocation;
      }
    } catch (_) {
      return AppStrings.unknownLocation;
    }
  }
}
