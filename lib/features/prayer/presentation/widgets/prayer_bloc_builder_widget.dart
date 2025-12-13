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
              fillProgress: _calculateFillProgress(state.countdownNextPrayer),
            ),

            PrayersTimeSection(state: state),
          ],
        );
      },
    );
  }

  double _calculateFillProgress(String countdown) {
    if (countdown.isEmpty) return 0.0;
    try {
      final parts = countdown.split(':');
      if (parts.length != 3) return 0.0;

      final duration = Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2]),
      );

      final totalSeconds = duration.inSeconds;
      const maxEffectSeconds = 7200;

      if (totalSeconds > maxEffectSeconds) {
        return 0.0;
      }

      return 1.0 - (totalSeconds / maxEffectSeconds);
    } catch (e) {
      return 0.0;
    }
  }
}
