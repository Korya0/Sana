// ignore_for_file: deprecated_member_use

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/data/get_prayers_list.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_card_content.dart';
import 'package:sana/core/services/date/cubit/app_date_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayersTimeSection extends StatelessWidget {
  final PrayerTimesState state;

  const PrayersTimeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.prayerTimes == null) return SizedBox();
    final prayers = getPrayersList(state.prayerTimes!);
    final now = context.read<AppDateCubit>().currentDate;
    Prayer? currentPrayer;
    Prayer? nextPrayer;

    for (var i = 0; i < prayers.length; i++) {
      final p = prayers[i];
      final nextIndex = (i + 1) % prayers.length;
      final nextTime = prayers[nextIndex].time;

      if (now.isAfter(p.time) && now.isBefore(nextTime)) {
        currentPrayer = p.prayer;
        nextPrayer = prayers[nextIndex].prayer;
        break;
      }
    }

    if (currentPrayer == null) {
      currentPrayer = prayers.last.prayer;
      nextPrayer = prayers.first.prayer;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Positioned(
            right: 91,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              color: AppColors.textWhite.withOpacity(0.1),
            ),
          ),
          Column(
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
        ],
      ),
    );
  }
}
