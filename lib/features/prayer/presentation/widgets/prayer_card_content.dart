import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_sunnah_bottom_sheet.dart';

class PrayerCardContent extends StatelessWidget {
  const PrayerCardContent({
    required this.name,
    required this.time,
    required this.isNext,
    super.key,
    this.isLast = false,
  });
  final String name;
  final String time;
  final bool isNext;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return AppAnimations.pressScale(
      onTap: () async {
        await showCustomBottomSheet(
          context,
          child: PrayerSunnahBottomSheet(
            prayerName: name,
            prayerTime: time.replaceAll('\n', ' '),
          ),
        );
      },
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  if (isNext)
                    AppColors.primary.withValues(alpha: 0.25)
                  else
                    AppColors.secondaryBackground.withValues(alpha: 0.25),
                  if (isNext)
                    AppColors.primary.withValues(alpha: 0.15)
                  else
                    AppColors.secondaryBackground.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: isNext
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: AppTextStyles.font12W700white(context).copyWith(
                    color: isNext ? AppColors.primary : AppColors.textWhite,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time.replaceAll('\n', ' '),
                  style: AppTextStyles.font12W700White(context).copyWith(
                    color: isNext
                        ? AppColors.primary.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
