import 'package:adhan/adhan.dart';

class PrayerInfo {

  PrayerInfo({
    required this.prayer,
    required this.time,
    required this.name,
    this.sunnah,
  });
  final Prayer prayer;
  final DateTime time;
  final String name;
  final String? sunnah;
}
