// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
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
              return PrayerCardContent(
                name: prayerInfo.name,
                time: prayerInfo.formattedTime(),
                isCurrent: state.currentPrayer == prayerInfo.prayer,
                isNext: state.nextPrayer == prayerInfo.prayer,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
