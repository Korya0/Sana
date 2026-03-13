import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentShareCard extends StatelessWidget {
  const DailyContentShareCard({
    required this.subTitle,
    super.key,
    this.title,
    this.source,
    this.department,
  });
  final String? title;
  final String subTitle;
  final String? source;
  final String? department;

  @override
  Widget build(BuildContext context) {
    // Determine dynamic department label if not provided
    final String finalDepartment;
    if (department != null) {
      finalDepartment = department!;
    } else {
      finalDepartment = title?.contains('حديث') == true
          ? AppStrings.fromHadith
          : AppStrings.fromSunnah;
    }

    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: customAppCardDecoration().copyWith(
          borderRadius: BorderRadius.zero,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -10,
              bottom: -20,
              child: Icon(
                SolarIconsBold.book,
                size: 150,
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null && title!.isNotEmpty) ...[
                    Text(
                      title!,
                      style: AppTextStyles.font22W700Gold(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    subTitle,
                    style: AppTextStyles.font26W700GoldQuran(
                      context,
                    ).copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (source != null && source!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      source!,
                      style: AppTextStyles.font14W400Gold(context),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 48),
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
