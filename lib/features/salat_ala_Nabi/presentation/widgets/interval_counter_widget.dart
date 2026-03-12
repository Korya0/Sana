import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_state.dart';
import 'package:solar_icons/solar_icons.dart';

/// Widget for adjusting reminder interval
class IntervalCounterWidget extends StatelessWidget {
  const IntervalCounterWidget({super.key});

  void _incrementInterval(BuildContext context, int currentInterval) {
    if (currentInterval < 120) {
      context.read<ReminderCubit>().updateInterval(currentInterval + 5);
    } else {
      AppToast.show(context, AppStrings.maxIntervalError);
    }
  }

  void _decrementInterval(BuildContext context, int currentInterval) {
    if (currentInterval > 15) {
      context.read<ReminderCubit>().updateInterval(currentInterval - 5);
    } else {
      AppToast.show(context, AppStrings.minIntervalError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is! ReminderLoaded) return const SizedBox.shrink();

        final intervalMinutes = state.settings.intervalMinutes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.intervalQuestion,
                  style: AppTextStyles.font16W600White(context),
                ),
                // subtitle
                Text(
                  AppStrings.intervalRangeNote,
                  style: AppTextStyles.font14W500Grey(context),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.betweenSections18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrease Button
                IconButton(
                  onPressed: () => _decrementInterval(context, intervalMinutes),
                  icon: const Icon(
                    SolarIconsBold.minusCircle,
                    color: AppColors.gold,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppDesign.betweenSections18),
                // Counter Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppStrings.minutes(intervalMinutes),
                    style: AppTextStyles.font18W700Gold(context),
                  ),
                ),
                const SizedBox(width: AppDesign.betweenSections18),
                // Increase Button
                IconButton(
                  onPressed: () => _incrementInterval(context, intervalMinutes),
                  icon: const Icon(
                    SolarIconsBold.addCircle,
                    color: AppColors.gold,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
