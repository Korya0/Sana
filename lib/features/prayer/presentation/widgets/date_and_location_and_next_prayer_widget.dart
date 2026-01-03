// ignore_for_file: deprecated_member_use, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/widgets/city_country_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/hijri_and_gregorian_date_widget.dart';

class DateAndLocationAndNextPrayerWidget extends StatelessWidget {
  final Widget countdownTimerWidget;
  final double fillProgress;

  const DateAndLocationAndNextPrayerWidget({
    super.key,
    required this.countdownTimerWidget,
    this.fillProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    // Progress calculation for background fill
    final double targetWidthPercent = fillProgress.clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background Progress Fill (Static/Efficient)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight, // Fill from right to left (RTL)
              child: FractionallySizedBox(
                widthFactor: targetWidthPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.2),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.green.withOpacity(0.0),
                        AppColors.green.withOpacity(0.3),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Section - const prevents rebuilds from Timer
                          HijriAndGregorianDateWidget(),

                          // Location Section - const prevents rebuilds from Timer
                          CityCountryWidget(),
                        ],
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
