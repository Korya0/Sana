import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/layout/custom_carousel_slider.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';
import 'package:sana/features/prayer/presentation/widgets/header/widgets/prayer_countdown_carousel_card.dart';
import 'package:sana/features/prayer/presentation/widgets/header/widgets/prayer_status_carousel_card.dart';
import 'package:sana/features/prayer/presentation/widgets/header/widgets/religious_event_carousel_card.dart';
import 'package:sana/features/prayer/utils/prayer_countdown_calculator.dart';

class HomePrayerCarousel extends StatelessWidget {
  const HomePrayerCarousel({
    required this.state,
    required this.durationListenable,
    super.key,
  });

  final PrayerTimesState state;
  final ValueListenable<String> durationListenable;

  @override
  Widget build(BuildContext context) {
    return CustomCarouselSlider(
      items: _buildCarouselItems(context),
      height: 60,
    );
  }

  List<Widget> _buildCarouselItems(BuildContext context) {
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      return [
        PrayerCountdownCarouselCard(
          durationListenable: durationListenable,
          nextPrayerName: PrayerCountdownCalculator.getRelevantPrayerName(
            currentState.prayers,
          ),
          isGracePeriod: PrayerCountdownCalculator.checkIsGracePeriod(
            currentState.prayers,
          ),
        ),

        if (currentState.currentStatus != null)
          PrayerStatusCarouselCard(
            status: currentState.currentStatus!,
          ),

        if (currentState.currentEvent != null)
          ReligiousEventCarouselCard(
            event: currentState.currentEvent!,
            isToday: currentState.isEventToday,
          ),
      ];
    }
    return [];
  }
}
