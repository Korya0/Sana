// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/widgets/hijri_and_gregorian_date_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/city_country_widget.dart';
import 'package:solar_icons/solar_icons.dart';

class DateAndLocationAndNextPrayerWidget extends StatelessWidget {
  final Widget countdownTimerWidget;

  const DateAndLocationAndNextPrayerWidget({
    super.key,
    required this.countdownTimerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withOpacity(0.4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular((12)),
          bottomRight: Radius.circular((12)),
        ),

        // boreader  from bottom left and right
        border: Border(
          bottom: BorderSide(
            color: AppColors.white.withOpacity(0.1),
            width: (1),
          ),
        ),
      ),

      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Date Section
                HijriAndGregorianDateWidget(),

                // Settings
                GestureDetector(
                  onTap: () => context.pushNamed(AppRoutes.settings),
                  child: Icon(SolarIconsBold.settings, size: (26)),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Location Section
            CityCountryWidget(),

            SizedBox(height: 16),

            // Countdown Section
            countdownTimerWidget,
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
