import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/countdown_timer.dart';
import 'package:sana/features/prayer/presentation/widgets/date_and_location_and_next_prayer_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline.dart';

class PrayerBlocBuilderWidget extends StatelessWidget {
  const PrayerBlocBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        return Column(
          children: [
            DateAndLocationAndNextPrayerWidget(
              countdownTimerWidget: CountdownTimer(
                duration: state.countdownNextPrayer,
                nextPrayerName: state.nextPrayerName ?? '',
              ),
              fillProgress: _calculateFillProgress(state),
            ),

            PrayersTimeSection(state: state),
          ],
        );
      },
    );
  }

  double _calculateFillProgress(PrayerTimesState state) {
    if (state.countdownNextPrayer.isEmpty || state.prayerTimes == null) {
      return 0.0;
    }

    try {
      final parts = state.countdownNextPrayer.split(':');
      if (parts.length != 3) return 0.0;

      final remainingDuration = Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2]),
      );

      final now = DateTime.now();
      final nextPrayerTime = now.add(remainingDuration);

      // Determine the previous prayer to define the start of the interval
      Prayer? previousPrayer;
      if (state.currentPrayer != null && state.currentPrayer != Prayer.none) {
        previousPrayer = state.currentPrayer;
      } else {
        // Fallback inference if currentPrayer is missing
        switch (state.nextPrayer) {
          case Prayer.fajr:
            previousPrayer = Prayer.isha;
            break;
          case Prayer.sunrise:
            previousPrayer = Prayer.fajr;
            break;
          case Prayer.dhuhr:
            previousPrayer = Prayer.sunrise;
            break;
          case Prayer.asr:
            previousPrayer = Prayer.dhuhr;
            break;
          case Prayer.maghrib:
            previousPrayer = Prayer.asr;
            break;
          case Prayer.isha:
            previousPrayer = Prayer.maghrib;
            break;
          default:
            previousPrayer = Prayer.fajr;
        }
      }

      DateTime? previousPrayerTime;
      // prayerTimes!.timeForPrayer returns DateTime for the *current* date of the PrayerTimes object
      if (previousPrayer != null) {
        // For Dhuhr following Sunrise, we should consider Sunrise time
        if (state.nextPrayer == Prayer.dhuhr &&
            previousPrayer == Prayer.sunrise) {
          previousPrayerTime = state.prayerTimes!.sunrise;
        } else {
          previousPrayerTime = state.prayerTimes!.timeForPrayer(previousPrayer);
        }
      }

      if (previousPrayerTime == null) return 0.0;

      // Adjust for day boundaries
      // If previous prayer time (e.g. 20:00) is after next prayer time (e.g. 05:00 next day)
      // or if previous prayer is after 'now', it implies it was yesterday.
      if (previousPrayerTime.isAfter(nextPrayerTime)) {
        previousPrayerTime = previousPrayerTime.subtract(
          const Duration(days: 1),
        );
      }

      // Also handle case where previous might be valid for 'today' but we are early morning
      // e.g. Now 2AM. Next 4AM. Prev (Isha) 8PM Today.
      // 8PM > 4AM -> subtract 1 day.

      final totalInterval = nextPrayerTime
          .difference(previousPrayerTime)
          .inSeconds;
      final elapsed = now.difference(previousPrayerTime).inSeconds;

      if (totalInterval <= 0) return 0.0;

      double progress = elapsed / totalInterval;
      return progress.clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }
}
