import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class PrayerCountdownCarouselCard extends StatelessWidget {
  const PrayerCountdownCarouselCard({
    required this.durationListenable,
    required this.nextPrayerName,
    required this.isGracePeriod,
    super.key,
  });

  final ValueListenable<String> durationListenable;
  final String nextPrayerName;
  final bool isGracePeriod;

  @override
  Widget build(BuildContext context) {
    final title = isGracePeriod
        ? '${AppStrings.currentPrayerTime} $nextPrayerName'
        : '${AppStrings.nextPrayerRemaining} $nextPrayerName';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.font12W500White(context).copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          ValueListenableBuilder<String>(
            valueListenable: durationListenable,
            builder: (context, duration, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    duration,
                    style: AppTextStyles.font22W700primary(
                      context,
                    ).copyWith(
                      height: 1,
                      letterSpacing: 1,
                    ),
                  ),
                  if (isGracePeriod) ...[
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.gracePeriodTitle,
                      style: AppTextStyles.font10W500Grey(context).copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        height: 1,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
