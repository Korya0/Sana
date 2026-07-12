class PrayerConstants {
  const PrayerConstants._();

  // Prayer Calculation Offsets & Grace Periods
  static const Duration gracePeriod10m = Duration(minutes: 10);
  static const Duration sunriseEndOffset15m = Duration(minutes: 15);
  static const Duration zenithStartOffset10m = Duration(minutes: 10);
  static const Duration dhuhaStartOffset20m = Duration(minutes: 20);
  static const Duration dhuhaEndOffset15m = Duration(minutes: 15);
}
