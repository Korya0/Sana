import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';
import 'package:solar_icons/solar_icons.dart';

class ZikrShareCard extends StatelessWidget {
  const ZikrShareCard({
    required this.text,
    super.key,
    this.subText,
  });
  final String text;
  final String? subText;

  @override
  Widget build(BuildContext context) {
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
              right: (-10).r(context),
              bottom: (-20).r(context),
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
                  ZikrShareContent(text: text, subText: subText),
                  const AppGap.h(AppSpacing.v32),
                  const CustomAppDivider(),
                  const AppGap.h(AppSpacing.v32),
                  const AppInfoShare(
                    department: AppStrings.azkarShareCardDepartment,
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
