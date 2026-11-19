import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class ZikrReorderCard extends StatelessWidget {
  const ZikrReorderCard({required this.zikr, super.key});

  final ZikrEntity zikr;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.fontZikrW700Primary(context, AppSize.f14);
    final lineHeight =
        style.fontSize! * (style.height ?? AppConstants.lineHeightCompact);
    final height =
        (lineHeight * AppConstants.maxTwoLines) +
        AppSize.p16 +
        (AppSize.borderWidth * AppConstants.boxBorderSides);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.p8),
      child: SizedBox(
        height: height,
        child: AppSectionCard(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.p16,
              vertical: AppSize.p8,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                zikr.text,
                maxLines: AppConstants.maxTwoLines,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
