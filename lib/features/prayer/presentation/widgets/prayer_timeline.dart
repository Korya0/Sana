// ignore_for_file: deprecated_member_use

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:sana/features/prayer/data/get_prayers_list.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_card_content.dart';

class PrayersTimeSection extends StatelessWidget {
  final PrayerTimesState state;

  const PrayersTimeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.prayerTimes == null) return SizedBox();
    final prayers = getPrayersList(state.prayerTimes!);
    final now = DateTime.now();

    Prayer? currentPrayer;
    Prayer? nextPrayer;

    for (var i = 0; i < prayers.length; i++) {
      final p = prayers[i];
      final nextTime = i < prayers.length - 1
          ? prayers[i + 1].time
          : DateTime(now.year, now.month, now.day, 23, 59);

      if (now.isAfter(p.time) && now.isBefore(nextTime)) {
        currentPrayer = p.prayer;
        nextPrayer =
            (i < prayers.length - 1 ? prayers[i + 1].prayer : prayers[0])
                as Prayer?;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: prayers.map((prayerInfo) {
          final isCurrent = prayerInfo.prayer == currentPrayer;
          final isNext = prayerInfo.prayer == nextPrayer;

          return PrayerCardContent(
            name: prayerInfo.name,
            time: prayerInfo.formattedTime(),
            isCurrent: isCurrent,
            isNext: isNext,
            isPrevious: !isCurrent && !isNext,
          );
        }).toList(),
      ),
    );
  }
}
