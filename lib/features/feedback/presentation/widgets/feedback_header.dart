import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackHeader extends StatelessWidget {
  const FeedbackHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              SolarIconsBold.lightbulb,
              color: AppColors.gold,
              size: 40,
            ),
          ),
        ),
        Text(
          AppStrings.feedbackSubTitle,
          style: AppTextStyles.font18W700White(context),
        ),
      ],
    );
  }
}
