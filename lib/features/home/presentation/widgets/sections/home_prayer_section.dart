import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/header/home_prayer_header.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline.dart';

class HomePrayerSection extends StatelessWidget {
  const HomePrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        return state.maybeWhen(
          success:
              (
                prayers,
                settings,
                timeRemaining,
                sunnahTimes,
                originPrayerTimes,
                currentEvent,
                isEventToday,
                currentStatus,
              ) {
                return Column(
                  children: [
                    HomePrayerHeader(state: state),
                    PrayersTimeSection(state: state),
                  ],
                );
              },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
