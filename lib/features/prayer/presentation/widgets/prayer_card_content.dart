// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline_node.dart';

class PrayerCardContent extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;
  final bool isCurrent;

  const PrayerCardContent({
    super.key,
    required this.name,
    required this.time,
    required this.isNext,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time Section
        SizedBox(
          width: (86),
          child: Text(
            time,
            style: isNext
                ? AppTextStyles.font18W700Gold(context)
                : AppTextStyles.font18W500White(context),
          ),
        ),

        // Timeline Node
        PrayerTimelineNode(isNext: isNext),

        SizedBox(width: (14)),

        // Details Card
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
              color: (isNext)
                  ? null
                  : AppColors.secondaryBackground.withOpacity(0.35),
              borderRadius: BorderRadius.circular((8)),
              border: isNext
                  ? Border.all(color: AppColors.gold.withOpacity(0.4))
                  : null,
            ),
            child: Text(
              name,
              style: isNext
                  ? AppTextStyles.font16W700White(context)
                  : AppTextStyles.font16W500White(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
