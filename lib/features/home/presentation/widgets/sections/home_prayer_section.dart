import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/home/presentation/widgets/skeleton/skeletonizer_home_prayer.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';
import 'package:sana/features/prayer/presentation/widgets/header/home_prayer_loaded.dart';

/// The prayer section displayed on the Home screen.
/// Integrated with Skeletonizer for loading states.
class HomePrayerSection extends StatelessWidget {
  const HomePrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoaded) {
          return HomePrayerLoaded(state: state);
        } else if (state is PrayerTimesError) {
          // Logically, we might want a retry button or error widget here, 
          // but for now we follow the existing pattern of shrinking.
          return const SizedBox.shrink();
        }
        return const SkeletonizerHomePrayer();
      },
    );
  }
}
