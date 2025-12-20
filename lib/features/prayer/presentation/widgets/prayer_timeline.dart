// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_card_content.dart';

class PrayersTimeSection extends StatelessWidget {
  final PrayerTimesState state;

  const PrayersTimeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.prayers.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Stack(
        children: [
          Positioned(
            right: 91,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              color: AppColors.textWhite.withOpacity(0.1),
            ),
          ),
          Column(
            children: state.prayers.map((prayer) {
              return PrayerCardContent(
                name: prayer.displayName,
                time: DateFormat(
                  AppConstants.timeFormat,
                  AppConstants.locale,
                ).format(prayer.time),
                isCurrent: prayer.isCurrent,
                isNext: prayer.isNext,
                isPrevious: !prayer.isCurrent && !prayer.isNext,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
