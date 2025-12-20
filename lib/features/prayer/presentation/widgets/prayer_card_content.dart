// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/custom_bottom_sheet.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/azkar/data/datasource/azkar_local_data_source.dart';
import 'package:sana/features/prayer/presentation/widgets/conditionally_prayer_card_show_message.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_sunnah_bottom_sheet.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline_node.dart';

class PrayerCardContent extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;
  final bool isPrevious;
  final bool isCurrent;

  const PrayerCardContent({
    super.key,
    required this.name,
    required this.time,
    required this.isNext,
    required this.isCurrent,
    this.isPrevious = false,
  });

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
                ? AppTextStyles.font15W700White(
                    context,
                  ).copyWith(fontSize: 16, color: AppColors.textPrimary)
                : AppTextStyles.font15W700White(context),
          ),
        ),

        // Timeline Node
        PrayerTimelineNode(isNext: isNext),

        SizedBox(width: 16),

        // Details Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              showCustomBottomSheet(
                context,
                child: PrayerSunnahBottomSheet(
                  prayerName: name,
                  prayerTime: time,
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                gradient: isNext
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gold.withOpacity(0.15),
                          AppColors.gold.withOpacity(0.05),
                        ],
                      )
                    : null,
                color: isNext
                    ? null
                    : AppColors.secondaryBackground.withOpacity(0.35),
                borderRadius: BorderRadius.circular(8),
                border: isNext
                    ? Border.all(color: AppColors.gold.withOpacity(0.4))
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // prayer name
                  Text(name, style: AppTextStyles.font15W700White(context)),

                  // conditionally show message
                  if (isNext)
                    ConditionallyPrayerCardShowMessage(
                      message: 'دعاء الاستفتاح',
                      onTap: () => context.pushNamed(
                        AppRoutes.azkar,
                        extra: StaticThikrData.allThikrCategories.last,
                      ),
                    ),

                  if (isCurrent)
                    ConditionallyPrayerCardShowMessage(
                      message: 'أذكار بعد الصلاة',
                      onTap: () => context.pushNamed(
                        AppRoutes.azkar,
                        extra: StaticThikrData.allThikrCategories.first,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
