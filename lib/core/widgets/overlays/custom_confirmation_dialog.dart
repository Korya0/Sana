import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';

class CustomConfirmationDialog {
  const CustomConfirmationDialog._();

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) => showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: context.color.secondaryScaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.r24),
      ),
      scrollable: true,
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: AppTextStyles.font16W700Primary(context),
      ),
      content: Text(
        message,
        textAlign: TextAlign.start,
        style: AppTextStyles.font14W500Secondary(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font14W700Secondary(context),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmText,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font14W700Brand(context),
          ),
        ),
      ],
    ),
  );
}
