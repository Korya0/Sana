import 'package:sana/features/prayer/data/models/prayer_type.dart';

class PrayerStateResult {
  const PrayerStateResult({
    required this.current,
    required this.next,
    required this.activePrayer,
    required this.statusId,
  });

  final PrayerType current;

  final PrayerType next;

  final PrayerType activePrayer;

  final String statusId;

  PrayerStateResult copyWith({
    PrayerType? current,
    PrayerType? next,
    PrayerType? activePrayer,
    String? statusId,
  }) {
    return PrayerStateResult(
      current: current ?? this.current,
      next: next ?? this.next,
      activePrayer: activePrayer ?? this.activePrayer,
      statusId: statusId ?? this.statusId,
    );
  }
}
