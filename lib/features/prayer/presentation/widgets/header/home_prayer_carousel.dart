import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/layout/custom_carousel_slider.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';
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
      height: 60, // Reverted to original compact height
    );
  }

  List<Widget> _buildCarouselItems(BuildContext context) {
    final prayers = state.prayers;

    return [
      // Card 1: Countdown & Next Prayer
      PrayerCountdownCarouselCard(
        durationListenable: durationListenable,
        nextPrayerName: PrayerCountdownCalculator.getRelevantPrayerName(
          prayers,
        ),
        isGracePeriod: PrayerCountdownCalculator.checkIsGracePeriod(prayers),
      ),

      // Card 2: Prayer Status (Tips/Sunan)
      if (state.currentStatus != null)
        PrayerStatusCarouselCard(
          status: state.currentStatus!,
        ),

      // Card 3: Religious Events
      if (state.currentEvent != null)
        ReligiousEventCarouselCard(
          event: state.currentEvent!,
          isToday: state.isEventToday,
        ),
    ];
  }
}
