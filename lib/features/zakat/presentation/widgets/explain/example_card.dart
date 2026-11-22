import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import '../zakat_info_card.dart';

class ExampleCard extends StatelessWidget {
  const ExampleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ZakatInfoCard(
      color: context.color.borderBrand.withValues(
        alpha: AppConstants.opacityGhost,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              AppStrings.zakatExampleTitle,
              style: AppTextStyles.font19W700Brand(context),
            ),
          ),
          AppGap.h(AppSize.p8),
          Text(
            AppStrings.zakatExampleBody,
            style: AppTextStyles.font16W400Loose(context),
          ),
        ],
      ),
    );
  }
}
