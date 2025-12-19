import 'package:adhan/adhan.dart';

class PrayerInfo {
  final Prayer prayer;
  final DateTime time;
  final String name;
  final String? sunnah;

  PrayerInfo({
    required this.prayer,
    required this.time,
    required this.name,
    this.sunnah,
  });
}
