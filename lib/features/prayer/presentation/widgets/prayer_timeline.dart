import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_card_content.dart';

class PrayersTimeSection extends StatelessWidget {
  const PrayersTimeSection({required this.state, super.key});
  final PrayerTimesState state;

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
              color: AppColors.textWhite.withValues(alpha: 0.1),
            ),
          ),
          Column(
            children: state.prayers.map((prayer) {
              final formattedTime =
                  '${DateFormat('h:mm', 'en').format(prayer.time)} ${DateFormat('a', 'ar').format(prayer.time)}';

              return PrayerCardContent(
                name: prayer.displayName,
                time: formattedTime,
                isCurrent: prayer.isCurrent,
                isNext: prayer.isNext,
                isPrevious: !prayer.isCurrent && !prayer.isNext,
                isLast: prayer == state.prayers.last,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
