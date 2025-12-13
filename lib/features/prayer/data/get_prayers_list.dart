import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/data/models/prayer_info.dart';

List<PrayerInfo> getPrayersList(PrayerTimes times) {
  return [
    PrayerInfo(prayer: Prayer.fajr, time: times.fajr, name: 'الفجر'),
    PrayerInfo(prayer: Prayer.dhuhr, time: times.dhuhr, name: 'الظهر'),
    PrayerInfo(prayer: Prayer.asr, time: times.asr, name: 'العصر'),
    PrayerInfo(prayer: Prayer.maghrib, time: times.maghrib, name: 'المغرب'),
    PrayerInfo(prayer: Prayer.isha, time: times.isha, name: 'العشاء'),
  ];
}
