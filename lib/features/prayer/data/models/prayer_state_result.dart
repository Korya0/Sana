import 'package:adhan/adhan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_state_result.freezed.dart';

/// Represents the result of calculating the current state of prayer times.
@freezed
class PrayerStateResult with _$PrayerStateResult {
  const factory PrayerStateResult({
    /// The current prayer (if any).
    required Prayer current,

    /// The next prayer.
    required Prayer next,

    /// The active prayer for display purposes (usually [current] if not none, else [next]).
    required Prayer activePrayer,

    /// The spiritual/virtue status ID for the current time window.
    required String statusId,
  }) = _PrayerStateResult;
}
