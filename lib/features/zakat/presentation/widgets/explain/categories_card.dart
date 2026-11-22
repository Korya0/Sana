import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import '../zakat_info_card.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({super.key, required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final accent = context.color.textBrand;

    return ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              AppStrings.zakatRecipientsTitle,
              style: AppTextStyles.font19W700Brand(context),
            ),
          ),
          AppGap.h(AppSize.p8),
          Text(
            AppStrings.zakatRecipientsIntro,
            style: AppTextStyles.font16W400Loose(context),
          ),
          AppGap.h(AppSize.p8),
          for (var i = 0; i < categories.length; i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.p4),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: CircleAvatar(
                      radius: AppSize.p16,
                      backgroundColor: accent.withValues(
                        alpha: AppConstants.opacityGhost,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: AppTextStyles.font13W700Brand(context),
                      ),
                    ),
                  ),
                  AppGap.w(AppSize.p12),
                  Expanded(
                    child: Text(
                      categories[i],
                      style: AppTextStyles.font16W400Primary(context),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
