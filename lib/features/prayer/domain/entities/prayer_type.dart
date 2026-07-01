enum PrayerType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  none;

  bool get isObligatory => this != sunrise && this != none;

  String get nameId => name;
}
