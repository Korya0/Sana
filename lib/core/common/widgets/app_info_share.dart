import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class AppInfoShare extends StatelessWidget {
  const AppInfoShare({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text
        Text(
          'تطبيق ${AppConstants.appName}',
          style: AppTextStyles.font16W700White(context),
          textAlign: TextAlign.center,
        ),
        // Logo
        Image.asset(AppAssetsImages.appLogo, width: (45), height: (45)),
      ],
    );
  }
}
