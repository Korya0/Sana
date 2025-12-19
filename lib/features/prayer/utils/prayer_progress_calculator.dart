import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

double calculateFillProgress(PrayerTimesState state, DateTime now) {
  if (state.nextPrayerTime == null || state.previousPrayerTime == null) {
    return 0.0;
  }

  // final now = DateTime.now(); // passed in
  final next = state.nextPrayerTime!;
  final prev = state.previousPrayerTime!;

  final totalInterval = next.difference(prev).inSeconds;
  final elapsed = now.difference(prev).inSeconds;

  if (totalInterval <= 0) return 0.0;

  double progress = elapsed / totalInterval;
  return progress.clamp(0.0, 1.0);
}
