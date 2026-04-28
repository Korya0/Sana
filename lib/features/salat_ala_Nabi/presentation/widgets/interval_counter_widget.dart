import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_state.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:sana/core/utils/app_feedback.dart';

class IntervalCounterWidget extends StatelessWidget {
  const IntervalCounterWidget({
    this.intervalMinutes,
    this.onIncrement,
    this.onDecrement,
    super.key,
  });

  final int? intervalMinutes;
  final ValueChanged<int>? onIncrement;
  final ValueChanged<int>? onDecrement;

  @override
  Widget build(BuildContext context) {
    if (intervalMinutes != null) {
      return _buildContent(context, intervalMinutes!);
    }

    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is! ReminderLoaded) return const SizedBox.shrink();
        final currentInterval = state.settings.intervalMinutes;
        final cubit = context.read<ReminderCubit>();

        return _buildContent(
          context,
          currentInterval,
          onIncrement: (val) {
            if (val < 120) {
              cubit.updateInterval(val + 5);
            } else {
              AppToast.show(context, AppStrings.maxIntervalError);
            }
          },
          onDecrement: (val) {
            if (val > 15) {
              cubit.updateInterval(val - 5);
            } else {
              AppToast.show(context, AppStrings.minIntervalError);
            }
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    int minutes, {
    ValueChanged<int>? onIncrement,
    ValueChanged<int>? onDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.v16),
      decoration: featureCardDecoration(
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
                style: AppTextStyles.font14W700White(context),
              ),
              Text(
                AppStrings.intervalRangeNote,
                style: AppTextStyles.font14W500Grey(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.v18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onDecrement != null
                    ? () {
                        unawaited(AppFeedback.playVibrate());
                        onDecrement(minutes);
                      }
                    : null,
                icon: Icon(
                  SolarIconsBold.minusCircle,
                  color: AppColors.iconPrimary,
                  size: 32.r(context),
                ),
              ),
              const SizedBox(width: AppSpacing.v18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.v24,
                  vertical: AppSpacing.v12,
                ),
                decoration: featureCardDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                  color: AppColors.scaffoldBackground,
                ),
                child: Text(
                  AppStrings.minutes(minutes),
                  style: AppTextStyles.font16W700primary(context),
                ),
              ),
              const SizedBox(width: AppSpacing.v18),
              IconButton(
                onPressed: onIncrement != null
                    ? () {
                        unawaited(AppFeedback.playVibrate());
                        onIncrement(minutes);
                      }
                    : null,
                icon: Icon(
                  SolarIconsBold.addCircle,
                  color: AppColors.iconPrimary,
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
