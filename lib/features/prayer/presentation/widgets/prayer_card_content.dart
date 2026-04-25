import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_action_link.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_sunnah_bottom_sheet.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline_node.dart';
import 'package:solar_icons/solar_icons.dart';

class PrayerCardContent extends StatelessWidget {
  const PrayerCardContent({
    required this.name,
    required this.time,
    required this.isNext,
    required this.isCurrent,
    super.key,
    this.isPrevious = false,
    this.isLast = false,
  });
  final String name;
  final String time;
  final bool isNext;
  final bool isPrevious;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time Section
        SizedBox(
          width: 86,
          child: Text(
            time,
            style: isNext
                ? AppTextStyles.font16W700primary(context)
                : AppTextStyles.font15W700White(context),
          ),
        ),

        // Timeline Node
        PrayerTimelineNode(isNext: isNext),

        const SizedBox(width: AppSpacing.v16),

        // Details Card
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 6, bottom: isLast ? 9 : 3),
            decoration: BoxDecoration(
              gradient: isNext
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                    )
                  : null,
              color: isNext
                  ? null
                  : AppColors.secondaryBackground.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(AppSpacing.radiusS),
              border: isNext
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                onTap: () async {
                  await showCustomBottomSheet(
                    context,
                    child: PrayerSunnahBottomSheet(
                      prayerName: name,
                      prayerTime: time,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.v8,
                    horizontal: AppSpacing.v8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // prayer name
                      Text(name, style: AppTextStyles.font15W700White(context)),

                      // conditionally show message
                      if (isNext)
                        PrayerActionLink(
                          message: AppStrings.openingPrayerAction,
                          onTap: () async {
                            await context.pushNamed(
                              AppRoutes.azkar,
                              pathParameters: {
                                'categoryId':
                                    AppStrings.openingPrayerCategoryId,
                              },
                            );
                          },
                        ),

                      if (isCurrent)
                        PrayerActionLink(
                          message: AppStrings.postPrayerAzkarAction,
                          onTap: () async {
                            await context.pushNamed(
                              AppRoutes.azkar,
                              pathParameters: {
                                'categoryId':
                                    AppStrings.postPrayerAzkarCategoryId,
                              },
                            );
                          },
                        ),

                      if (!isNext && !isCurrent)
                        const Icon(
                          SolarIconsBold.altArrowLeft,
                          size: 14,
                          color: AppColors.iconWhite,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
