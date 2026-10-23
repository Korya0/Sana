import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';

class CustomConfirmationDialog {
  const CustomConfirmationDialog._();

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.color.secondaryScaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.r16),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: AppSize.p24),
        child: Padding(
          padding: EdgeInsets.all(AppSize.p16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font20W700Primary(context),
                ),
                AppGap.h(AppSize.p16),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16W500Primary(context),
                ),
                AppGap.h(AppSize.p24),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: AppSecondaryButton(
                        label: cancelText,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ),
                    AppGap.w(AppSize.p12),
                    Expanded(
                      child: AppPrimaryButton(
                        label: confirmText,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
