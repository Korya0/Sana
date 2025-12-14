import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/countdown_timer.dart';
import 'package:sana/features/prayer/presentation/widgets/date_and_location_and_next_prayer_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline.dart';
import 'package:sana/features/prayer/utils/prayer_progress_calculator.dart';

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
              fillProgress: calculateFillProgress(state),
            ),

            PrayersTimeSection(state: state),
          ],
        );
      },
    );
  }
}
