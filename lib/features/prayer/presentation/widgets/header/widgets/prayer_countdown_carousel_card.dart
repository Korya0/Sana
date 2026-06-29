import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

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
            style: AppTextStyles.font12W500(context).copyWith(
              color: context.color.textSecondary,
            ),
          ),
          ValueListenableBuilder<String>(
            valueListenable: durationListenable,
            builder: (context, duration, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    duration,
                    style:
                        AppTextStyles.font24W700(
                          context,
                        ).copyWith(
                          height: 1,
                          letterSpacing: 3,
                          color: context.color.textAccent,
                        ),
                  ),
                  if (isGracePeriod) ...[
                    const SizedBox(height: AppSpacing.v4),
                    Text(
                      AppStrings.gracePeriodTitle,
                      style: AppTextStyles.font12W500(context).copyWith(
                        color: context.color.textSecondary,
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
