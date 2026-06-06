import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

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
            style: AppTextStyles.font11W500(context).copyWith(
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
                        AppTextStyles.font22W700(
                          context,
                        ).copyWith(
                          height: 1,
                          letterSpacing: 3,
                        ),
                  ),
                  if (isGracePeriod) ...[
                    const SizedBox(height: AppSpacing.v4),
                    Text(
                      AppStrings.gracePeriodTitle,
                      style: AppTextStyles.font11W500(context).copyWith(
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
