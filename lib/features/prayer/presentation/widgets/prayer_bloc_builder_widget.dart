import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timer_builder.dart';

class PrayerBlocBuilderWidget extends StatelessWidget {
  const PrayerBlocBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      buildWhen: (previous, current) {
        return previous.prayers.length != current.prayers.length ||
            previous.prayers.any((p) => p.isNext) !=
                current.prayers.any((p) => p.isNext);
      },
      builder: (context, state) {
        return Column(
          children: [
            PrayerTimerBuilder(state: state),
            PrayersTimeSection(state: state),
          ],
        );
      },
    );
  }
}
