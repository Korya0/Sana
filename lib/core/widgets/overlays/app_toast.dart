import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

enum AppToastType { info, success, error }

class AppToast {
  const AppToast._();

  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
  }) {
    final color = switch (type) {
      AppToastType.info => AppColorsCommon.infoColor,
      AppToastType.success => AppColorsCommon.successColor,
      AppToastType.error => AppColorsCommon.errorColor,
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.start,
            style: AppTextStyles.font14W700White(context),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(AppSize.p16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.r12),
          ),
          duration: AppConstants.toastDuration1500ms,
        ),
      );
  }
}
