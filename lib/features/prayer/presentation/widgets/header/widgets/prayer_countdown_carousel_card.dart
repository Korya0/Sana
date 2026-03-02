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
            style: AppTextStyles.font16W700White(context).copyWith(
              height: 1,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<String>(
            valueListenable: durationListenable,
            builder: (context, duration, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    duration,
                    style: AppTextStyles.font26W900Gold(context).copyWith(
                      letterSpacing: 2,
                      height: 1,
                      fontSize: 26,
                    ),
                  ),
                  if (isGracePeriod) ...[
                    Text(
                      AppStrings.gracePeriodTitle,
                      style: AppTextStyles.font12W500White(context).copyWith(
                        color: Colors.white.withAlpha(180),
                        fontSize: 10,
                        height: 1.1,
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
