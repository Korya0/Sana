import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:solar_icons/solar_icons.dart';

import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

class DailyContentShareCard extends StatelessWidget {
  const DailyContentShareCard({
    required this.subTitle,
    this.type,
    super.key,
    this.title,
    this.source,
    this.department,
  });
  final String? title;
  final String subTitle;
  final String? source;
  final String? department;
  final DailyContentType? type;

  static const double _bgIconRight = -10;
  static const double _bgIconBottom = -20;
  static const double _bgIconSize = 150;

  @override
  Widget build(BuildContext context) {
    final String finalDepartment;
    if (department != null) {
      finalDepartment = department!;
    } else {
      finalDepartment = type == DailyContentType.hadith
          ? AppStrings.fromHadith
          : AppStrings.fromSunnah;
    }

    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: customAppCardDecoration(context).copyWith(
          borderRadius: BorderRadius.zero,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: _bgIconRight,
              bottom: _bgIconBottom,
              child: Icon(
                SolarIconsBold.book,
                size: _bgIconSize.r(context),
                color: context.color.textPrimary.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.v24,
                vertical: AppSpacing.v40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null && title!.isNotEmpty) ...[
                    Text(
                      title!,
                      style: AppTextStyles.font24W700(
                        context,
                      ).copyWith(color: context.color.textAccent),
                      textAlign: TextAlign.center,
                    ),
                    const AppGap.h(AppSpacing.v20),
                  ],
                  Text(
                    subTitle,
                    style: AppTextStyles.fontQuran26W400White(context),
                    textAlign: TextAlign.center,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (source != null && source!.isNotEmpty) ...[
                    const AppGap.h(AppSpacing.v20),
                    Text(
                      source!,
                      style: AppTextStyles.font14W500(
                        context,
                      ).copyWith(color: context.color.textAccent),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const AppGap.h(AppSpacing.v48),
                  AppInfoShare(department: finalDepartment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
