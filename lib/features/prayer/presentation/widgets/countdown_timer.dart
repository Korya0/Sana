import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({
    required this.duration, required this.nextPrayerName, super.key,
  });
  final String duration;
  final String nextPrayerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        Text(
          'باقي على $nextPrayerName',
          style: AppTextStyles.font16W700White(context).copyWith(height: 1),
        ),
        Text(
          duration,
          style: AppTextStyles.font26W900Gold(
            context,
          ).copyWith(letterSpacing: 6, height: 1),
        ),
      ],
    );
  }
}
