import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({
    super.key,
    required this.duration,
    required this.nextPrayerName,
  });
  final String? duration;
  final String nextPrayerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        if (duration != null) ...[
          Text(
            'باقي على $nextPrayerName',
            style: AppTextStyles.font16W700White(context),
          ),
          Text(duration!, style: AppTextStyles.font32W900Gold(context)),
        ] else ...[
          Skeletonizer(
            child: Column(
              spacing: 4,
              children: [
                Text(
                  'باقي على $nextPrayerName',
                  style: AppTextStyles.font16W700White(context),
                ),
                Text("00:00:00", style: AppTextStyles.font32W900Gold(context)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
