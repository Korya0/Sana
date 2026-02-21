import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class SplashLogoAndName extends StatelessWidget {
  const SplashLogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // app name
        Text(
          AppConstants.appName,
          style: AppTextStyles.font50W900White(context),
        ),

        // app logo Svgs
        SvgPicture.asset(AppAssetsSvgs.appLogo, width: 80),
      ],
    );
  }
}
