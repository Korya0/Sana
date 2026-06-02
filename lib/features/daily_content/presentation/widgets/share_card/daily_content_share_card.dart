import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharing/presentation/app_info_share.dart';
import 'package:sana/core/services/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
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

  static const double _bgIconRight = -10;
  static const double _bgIconBottom = -20;
  static const double _bgIconSize = 150;

  @override
  Widget build(BuildContext context) {
    final String finalDepartment;
    if (department != null) {
      finalDepartment = department!;
    } else {
      finalDepartment = title?.contains(AppStrings.hadith) == true
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
              right: _bgIconRight,
              bottom: _bgIconBottom,
              child: Icon(
                SolarIconsBold.book,
                size: _bgIconSize,
                color: AppColors.textPrimary.withValues(alpha: 0.05),
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
                      style: AppTextStyles.font22W700primary(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.v20),
                  ],
                  Text(
                    subTitle,
                    style: AppTextStyles.fontQuran26W400White(context),
                    textAlign: TextAlign.center,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (source != null && source!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.v20),
                    Text(
                      source!,
                      style: AppTextStyles.font14W400primary(context),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.v48),
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


