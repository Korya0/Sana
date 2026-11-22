import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final foreground = context.color.textOnPrimary;

    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: AppSize.p32,
          horizontal: AppSize.p20,
        ),
        decoration: BoxDecoration(
          color: context.color.surfaceBrand,
          borderRadius: BorderRadius.circular(AppSize.r24),
        ),
        child: Column(
          children: [
            ExcludeSemantics(
              child: Container(
                padding: EdgeInsets.all(AppSize.p16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: foreground, width: AppSize.w4),
                ),
                child: Icon(
                  AppIcons.charity,
                  size: AppSize.icon48,
                  color: foreground,
                ),
              ),
            ),
            AppGap.h(AppSize.p16),
            Text(
              AppStrings.zakatTitle,
              style: AppTextStyles.font40W700OnColor(context, foreground),
            ),
            AppGap.h(AppSize.p12),
            Text(
              AppStrings.zakatSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.font18W500OnColor(context, foreground)
                  .copyWith(
                    height: AppConstants.lineHeightBodyRelaxed,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
