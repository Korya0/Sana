import 'package:sana/features/prayer/data/models/prayer_display_model.dart';

class PrayerCountdownCalculator {
  static const Duration gracePeriodDuration = Duration(minutes: 10);

  static String calculateCountdown(List<PrayerDisplayModel> prayers) {
    if (prayers.isEmpty) return '00:00:00';

    final now = DateTime.now();

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

    final nextPrayer = _getNextPrayer(prayers);
    final diff = nextPrayer.time.difference(now);

    if (diff.isNegative || diff.inSeconds == 0) {
      return '00:00:00';
    }

    return _formatDuration(diff);
  }

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
