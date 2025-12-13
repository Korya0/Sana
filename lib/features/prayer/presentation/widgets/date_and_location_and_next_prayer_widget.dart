// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/widgets/hijri_and_gregorian_date_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/city_country_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/water_wave_widget.dart';
import 'package:solar_icons/solar_icons.dart';

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
    final double targetHeightPercent = (1.0 - fillProgress).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withOpacity(0.4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular((12)),
          bottomRight: Radius.circular((12)),
        ),

        border: Border(
          bottom: BorderSide(
            color: AppColors.white.withOpacity(0.1),
            width: (1),
          ),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: WaterWaveWidget(
                color: AppColors.green,
                duration: Duration(seconds: 4),
                waveAmplitude: 12.0,
                waveFrequency: .8,
                heightPercent: targetHeightPercent,
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Section
                          HijriAndGregorianDateWidget(),
                          // Location Section
                          CityCountryWidget(),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Countdown Section
                      countdownTimerWidget,
                      SizedBox(height: 4),
                    ],
                  ),

                  // Settings
                  Positioned(
                    bottom: 20,
                    left: 0,
                    child: GestureDetector(
                      onTap: () => context.pushNamed(AppRoutes.settings),
                      child: Icon(SolarIconsOutline.settings, size: 24),
                    ),
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
