import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:sana/core/utils/app_feedback.dart';

class IntervalCounterWidget extends StatelessWidget {
  const IntervalCounterWidget({
    required this.intervalMinutes,
    this.onIntervalChanged,
    super.key,
  });

  final int intervalMinutes;
  final ValueChanged<int>? onIntervalChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.v16),
      decoration: featureCardDecoration(context: context, 
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: AppSpacing.v4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.intervalQuestion,
                style: AppTextStyles.font14W700(context).copyWith(color: context.color.textPrimary),
              ),
              Text(
                AppStrings.intervalRangeNote,
                style: AppTextStyles.font14W500(context).copyWith(color: context.color.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.v18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onIntervalChanged != null
                    ? () {
                        unawaited(AppFeedback.playVibrate());
                        if (intervalMinutes > 15) {
                          onIntervalChanged!(intervalMinutes - 5);
                        } else {
                          AppToast.show(context, AppStrings.minIntervalError);
                        }
                      }
                    : null,
                icon: Icon(
                  SolarIconsBold.minusCircle,
                  color: context.color.primary,
                  size: 32.r(context),
                ),
              ),
              const SizedBox(width: AppSpacing.v18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.v24,
                  vertical: AppSpacing.v12,
                ),
                decoration: featureCardDecoration(context: context, 
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                child: Text(
                  AppStrings.minutes(intervalMinutes),
                  style: AppTextStyles.font16W700(context).copyWith(color: context.color.textAccent),
                ),
              ),
              const SizedBox(width: AppSpacing.v18),
              IconButton(
                onPressed: onIntervalChanged != null
                    ? () {
                        unawaited(AppFeedback.playVibrate());
                        if (intervalMinutes < 120) {
                          onIntervalChanged!(intervalMinutes + 5);
                        } else {
                          AppToast.show(context, AppStrings.maxIntervalError);
                        }
                      }
                    : null,
                icon: Icon(
                  SolarIconsBold.addCircle,
                  color: context.color.primary,
                  size: 32.r(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

