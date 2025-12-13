// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomAppDivider extends StatelessWidget {
  const CustomAppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: (8)),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withOpacity(0.0),
                  AppColors.gold.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              SolarIconsBold.star,
              color: AppColors.gold.withOpacity(0.4),
              size: (8),
            ),
            SizedBox(width: (4)),
            Container(
              padding: EdgeInsets.all((4)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                SolarIconsBold.star,
                color: AppColors.gold,
                size: (12),
              ),
            ),
            SizedBox(width: (4)),
            Icon(
              SolarIconsBold.star,
              color: AppColors.gold.withOpacity(0.4),
              size: (8),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: (8)),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withOpacity(0.5),
                  AppColors.gold.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
