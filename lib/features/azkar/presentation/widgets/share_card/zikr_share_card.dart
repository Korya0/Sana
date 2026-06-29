import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/app_info_share.dart';
import 'package:sana/core/services/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
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
                size: 150.r(context),
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
                  ZikrContent(text: text, subText: subText, isSharing: true),
                  const SizedBox(height: AppSpacing.v32),
                  const CustomAppDivider(),
                  const SizedBox(height: AppSpacing.v32),
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

