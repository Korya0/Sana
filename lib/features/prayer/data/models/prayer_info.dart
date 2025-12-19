import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

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

  String formattedTime({required String locale}) {
    return DateFormat('hh:mm a', locale).format(time);
  }
}
