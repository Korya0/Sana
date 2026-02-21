import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/widgets/city_country_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/hijri_and_gregorian_date_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/wave_progress_widget.dart';

class DateAndLocationAndNextPrayerWidget extends StatelessWidget {
  const DateAndLocationAndNextPrayerWidget({
    required this.countdownTimerWidget,
    super.key,
    this.fillProgress = 0.0,
  });
  final Widget countdownTimerWidget;
  final double fillProgress;

  @override
  Widget build(BuildContext context) {
    // Progress calculation for background fill
    final targetWidthPercent = fillProgress.clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withValues(alpha: 0.4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background Progress Fill (Static/Efficient)
          // Background Progress Fill (Wave Effect)
          Positioned.fill(
            child: WaveProgressWidget(
              progress: targetWidthPercent,
              color: AppColors.green.withValues(alpha: 0.25),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: kIsWeb ? 16 : 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date Section - const prevents rebuilds from Timer
                            HijriAndGregorianDateWidget(),

                            // Location Section - const prevents rebuilds from Timer
                            CityCountryWidget(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Countdown Section - This one rebuilds
                      countdownTimerWidget,
                      const SizedBox(height: 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
