import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomAppDivider extends StatelessWidget {
  const CustomAppDivider({this.isVertical = false, super.key});

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.v8),
              width: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0),
                    AppColors.primary.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                SolarIconsBold.star,
                color: AppColors.primary.withValues(alpha: 0.4),
                size: 8,
              ),
              const SizedBox(height: AppSpacing.v4),
              Container(
                padding: const EdgeInsets.all(AppSpacing.v4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  SolarIconsBold.star,
                  color: AppColors.primary,
                  size: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.v4),
              Icon(
                SolarIconsBold.star,
                color: AppColors.primary.withValues(alpha: 0.4),
                size: 8,
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.v8),
              width: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.5),
                    AppColors.primary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.v8),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0),
                  AppColors.primary.withValues(alpha: 0.5),
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
              color: AppColors.primary.withValues(alpha: 0.4),
              size: 8,
            ),
            const SizedBox(width: AppSpacing.v4),
            Container(
              padding: const EdgeInsets.all(AppSpacing.v4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                SolarIconsBold.star,
                color: AppColors.primary,
                size: 12,
              ),
            ),
            const SizedBox(width: AppSpacing.v4),
            Icon(
              SolarIconsBold.star,
              color: AppColors.primary.withValues(alpha: 0.4),
              size: 8,
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.v8),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.5),
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
