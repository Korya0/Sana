import 'package:sana/features/prayer/data/models/prayer_display_model.dart';

class PrayerCountdownCalculator {
  /// The duration of the grace period after a prayer starts.
  static const Duration gracePeriodDuration = Duration(minutes: 10);

  /// Calculates the countdown string for the next prayer or grace period.
  static String calculateCountdown(List<PrayerDisplayModel> prayers) {
    if (prayers.isEmpty) return '00:00:00';

    final now = DateTime.now();

    // Check if we are in the grace period of the current prayer
    final currentPrayer = _getCurrentPrayer(prayers);
    if (currentPrayer != null) {
      final elapsedSinceStart = now.difference(currentPrayer.time);
      if (elapsedSinceStart.inSeconds >= 0 &&
          elapsedSinceStart < gracePeriodDuration) {
        final remainingGrace =
            gracePeriodDuration.inSeconds - elapsedSinceStart.inSeconds;
        return _formatDuration(Duration(seconds: remainingGrace));
      }
    }

    // Otherwise, calculate countdown to the next prayer
    final nextPrayer = _getNextPrayer(prayers);
    final diff = nextPrayer.time.difference(now);

    if (diff.isNegative || diff.inSeconds == 0) {
      return '00:00:00';
    }

    return _formatDuration(diff);
  }

  /// Determines if the current time is within the grace period of a prayer.
  static bool checkIsGracePeriod(List<PrayerDisplayModel> prayers) {
    if (prayers.isEmpty) return false;

    final now = DateTime.now();
    final currentPrayer = _getCurrentPrayer(prayers);

    if (currentPrayer != null) {
      final elapsedSinceStart = now.difference(currentPrayer.time);
      return elapsedSinceStart.inSeconds >= 0 &&
          elapsedSinceStart < gracePeriodDuration;
    }
    return false;
  }

  /// Returns the display name of the relevant prayer (current if grace, otherwise next).
  static String getRelevantPrayerName(List<PrayerDisplayModel> prayers) {
    if (prayers.isEmpty) return '';

    if (checkIsGracePeriod(prayers)) {
      return _getCurrentPrayer(prayers)?.displayName ?? '';
    }
    return _getNextPrayer(prayers).displayName;
  }

  static PrayerDisplayModel? _getCurrentPrayer(
    List<PrayerDisplayModel> prayers,
  ) {
    return prayers.where((p) => p.isCurrent).firstOrNull;
  }

  static PrayerDisplayModel _getNextPrayer(List<PrayerDisplayModel> prayers) {
    return prayers.where((p) => p.isNext).firstOrNull ?? prayers.first;
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
