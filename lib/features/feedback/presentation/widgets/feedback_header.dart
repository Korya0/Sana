import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackHeader extends StatelessWidget {
  const FeedbackHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.v24,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.v20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: context.color.primary.withValues(alpha: 0.3),
                width: 2.r(context),
              ),
            ),
            child: Icon(
              SolarIconsBold.lightbulb,
              color: context.color.primary,
              size: 40.r(context),
            ),
          ),
        ),
        Text(
          AppStrings.feedbackSubTitle,
          style: AppTextStyles.font16W700White(context),
        ),
      ],
    );
  }
}

