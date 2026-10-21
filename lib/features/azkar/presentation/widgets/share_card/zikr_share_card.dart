import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';

class ZikrShareCard extends StatelessWidget {
  const ZikrShareCard({
    required this.text,
    super.key,
    this.subText,
  });

  final String text;
  final String? subText;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    constraints: const BoxConstraints(
      maxWidth: AppSize.shareCardMaxWidth,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.p24,
      vertical: AppSize.p40,
    ),
    decoration: BoxDecoration(
      color: context.color.secondaryScaffoldBackgroundColor,
      border: Border.all(
        color: context.color.borderBrand,
        width: AppSize.borderWidth,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App identity
        SvgPicture.asset(AppAssets.logo, height: AppSize.h56),
        AppGap.h(AppSize.p8),
        Text(
          AppStrings.appName,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font16W700Primary(context),
        ),
        AppGap.h(AppSize.p24),
        const CustomAppDivider(),
        AppGap.h(AppSize.p24),

        // Zikr
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.fontQuran24W400Primary(context),
        ),
        if (subText != null && subText!.isNotEmpty) ...[
          AppGap.h(AppSize.p16),
          Text(
            subText!,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14W500Secondary(context),
          ),
        ],
        AppGap.h(AppSize.p24),
        const CustomAppDivider(),
        AppGap.h(AppSize.p16),

        // Department
        Text(
          AppStrings.azkarShareCardDepartment,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12W500Secondary(context),
        ),
      ],
    ),
  );
}
