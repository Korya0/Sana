import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

double calculateFillProgress(PrayerTimesState state, DateTime now) {
  // Get current and next prayer from state
  final currentPrayer = state.prayers.where((p) => p.isCurrent).firstOrNull;
  final nextPrayer = state.prayers.where((p) => p.isNext).firstOrNull;

  if (currentPrayer == null || nextPrayer == null) {
    return 0;
  }

  final next = nextPrayer.time;
  final prev = currentPrayer.time;

  final totalInterval = next.difference(prev).inSeconds;
  final elapsed = now.difference(prev).inSeconds;

  if (totalInterval <= 0) return 0;

  final progress = elapsed / totalInterval;
  return progress.clamp(0.0, 1.0);
}
