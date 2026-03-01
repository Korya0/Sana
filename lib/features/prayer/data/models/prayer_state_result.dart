import 'package:adhan/adhan.dart';

/// Represents the result of calculating the current state of prayer times.
class PrayerStateResult {
  const PrayerStateResult({
    required this.current,
    required this.next,
    required this.activePrayer,
    required this.statusId,
  });

  /// The current prayer (if any).
  final Prayer current;

  /// The next prayer.
  final Prayer next;

  /// The active prayer for display purposes (usually [current] if not none, else [next]).
  final Prayer activePrayer;

  /// The spiritual/virtue status ID for the current time window.
  final String statusId;
}
