import 'package:flutter/foundation.dart';
import 'package:sana/features/prayer/domain/entities/prayer_type.dart';

@immutable
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrayerStateResult) return false;
    return current == other.current &&
        next == other.next &&
        activePrayer == other.activePrayer &&
        statusId == other.statusId;
  }

  @override
  int get hashCode =>
      current.hashCode ^
      next.hashCode ^
      activePrayer.hashCode ^
      statusId.hashCode;
}
