import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithShareCard extends StatelessWidget {
  const HadithShareCard({
    required this.hadith,
    super.key,
  });
  final HadithEntity hadith;

  Color _getJudgmentColor(String? judgment) {
    if (judgment == null) return AppColors.primary;
    final j = judgment.toLowerCase();
    if (j.contains('صحيح') || j.contains('جيد') || j.contains('ثابت')) {
      return Colors.green.shade400;
    }
    if (j.contains('حسن')) {
      return AppColors.primary;
    }
    if (j.contains('ضعيف') ||
        j.contains('منكر') ||
        j.contains('لا يصح') ||
        j.contains('موضوع') ||
        j.contains('باطل') ||
        j.contains('كذب')) {
      return Colors.red.shade400;
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final judgmentColor = _getJudgmentColor(hadith.judgment);
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
                color: AppColors.iconWhite.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: HadithContentWidget(
                      htmlContent: hadith.hadithContent,
                      isCentered: true,
                      isSharing: true,
                      judgmentColor: judgmentColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const CustomAppDivider(),
                  const SizedBox(height: 32),
                  const AppInfoShare(
                    department: AppStrings.hadithSearchShareCardDepartment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
