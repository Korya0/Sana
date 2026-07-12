import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/app_info_share.dart';
import 'package:sana/core/services/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithShareCard extends StatelessWidget {
  const HadithShareCard({
    required this.hadith,
    super.key,
  });
  final HadithEntity hadith;

  Color _getJudgmentColor(BuildContext context, String? judgment) {
    if (judgment == null) return context.color.primary;
    final j = judgment.toLowerCase();
    if (j.contains('صحيح') || j.contains('جيد') || j.contains('ثابت')) {
      return Colors.green.shade400;
    }
    if (j.contains('حسن')) {
      return context.color.primary;
    }
    if (j.contains('ضعيف') ||
        j.contains('منكر') ||
        j.contains('لا يصح') ||
        j.contains('موضوع') ||
        j.contains('باطل') ||
        j.contains('كذب')) {
      return Colors.red.shade400;
    }
    return context.color.primary;
  }

  @override
  Widget build(BuildContext context) {
    final judgmentColor = _getJudgmentColor(context, hadith.judgment);
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
              right: -AppSpacing.v12,
              bottom: -AppSpacing.v20,
              child: Icon(
                SolarIconsBold.book,
                size: AppSpacing.s150.r(context),
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
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 500.r(context)),
                    child: HadithContentWidget(
                      htmlContent: hadith.hadithContent,
                      isCentered: true,
                      isSharing: true,
                      judgmentColor: judgmentColor,
                    ),
                  ),
                  const AppGap.h(AppSpacing.v32),
                  const CustomAppDivider(),
                  const AppGap.h(AppSpacing.v32),
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
