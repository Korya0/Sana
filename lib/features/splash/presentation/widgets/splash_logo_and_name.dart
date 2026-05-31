import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/generated/assets.gen.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

class SplashLogoAndName extends StatelessWidget {
  const SplashLogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.v6,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,

      children: [
        // app name
        Text(
          AppConstants.appName,
          style: AppTextStyles.font50W700White(context).copyWith(),
        ),

        // app logo Svgs
        SvgPicture.asset(
          Assets.svgs.appLogo,
          width: 80.r(context),
        ),
      ],
    );
  }
}

