import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/home/presentation/widgets/skeleton/skeletonizer_home_prayer.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';
import 'package:sana/features/prayer/presentation/widgets/header/home_prayer_loaded.dart';

class HomePrayerSection extends StatelessWidget {
  const HomePrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoaded) {
          return HomePrayerLoaded(state: state);
        } else if (state is PrayerTimesError) {
          return const SizedBox.shrink();
        }
        return const SkeletonizerHomePrayer();
      },
    );
  }
}
