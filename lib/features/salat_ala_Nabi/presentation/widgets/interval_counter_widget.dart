import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/cubit/reminder_cubit.dart';
import 'package:solar_icons/solar_icons.dart';

/// Widget for adjusting reminder interval
class IntervalCounterWidget extends StatelessWidget {
  const IntervalCounterWidget({super.key});

  void _incrementInterval(BuildContext context, int currentInterval) {
    if (currentInterval < 120) {
      context.read<ReminderCubit>().updateInterval(currentInterval + 5);
    } else {
      AppToast.show(context, 'الحد الأقصى 120 دقيقة');
    }
  }

  void _decrementInterval(BuildContext context, int currentInterval) {
    if (currentInterval > 15) {
      context.read<ReminderCubit>().updateInterval(currentInterval - 5);
    } else {
      AppToast.show(context, 'الحد الأدنى 15 دقيقة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderSettings?>(
      builder: (context, settings) {
        if (settings == null) return const SizedBox.shrink();

        final intervalMinutes = settings.intervalMinutes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التكرار كل كم دقيقة (تقريباً)',
                  style: AppTextStyles.font16W600White(context),
                ),
                // subtitle
                Text(
                  'المدة بين 15-120 دقيقة • قد يختلف التوقيت الفعلي قليلاً',
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
                    '$intervalMinutes دقيقة',
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
