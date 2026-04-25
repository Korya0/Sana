import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_card_content.dart';

class PrayersTimeSection extends StatelessWidget {
  const PrayersTimeSection({required this.state, super.key});
  final PrayerTimesState state;

  @override
  Widget build(BuildContext context) {
    final currentState = state;
    if (currentState is PrayerTimesLoaded) {
      final prayers = currentState.prayers;
      if (prayers.isEmpty) return const SizedBox();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          mainAxisSpacing: 4,
          crossAxisSpacing: 6,
          childAspectRatio: 1.4,
          children: prayers.map((prayer) {
            final formattedTime = DateFormat('h:mm', 'en').format(prayer.time);
            final period = DateFormat('a', 'ar').format(prayer.time);

            return PrayerCardContent(
              name: prayer.displayName,
              time: '$formattedTime\n$period',
              isNext: prayer.isNext,
              isLast: prayer == prayers.last,
            );
          }).toList(),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
