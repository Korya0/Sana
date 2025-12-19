import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

class PrayerCalculationParams {
  final UserPrayerTimesSettings settings;
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final String locale;

  PrayerCalculationParams({
    required this.settings,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    required this.locale,
  });

  Coordinates get coords => Coordinates(latitude, longitude);
}
