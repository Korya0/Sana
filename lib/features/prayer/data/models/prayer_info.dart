import 'package:sana/features/prayer/data/models/prayer_type.dart';

class PrayerInfo {
  const PrayerInfo({
    required this.prayer,
    required this.time,
    required this.name,
    this.sunnah,
  });

  final PrayerType prayer;
  final DateTime time;
  final String name;
  final String? sunnah;

  PrayerInfo copyWith({
    PrayerType? prayer,
    DateTime? time,
    String? name,
    String? sunnah,
  }) {
    return PrayerInfo(
      prayer: prayer ?? this.prayer,
      time: time ?? this.time,
      name: name ?? this.name,
      sunnah: sunnah ?? this.sunnah,
    );
  }
}
