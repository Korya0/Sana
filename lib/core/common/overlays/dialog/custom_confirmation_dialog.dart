import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/context_extension.dart';

class CustomConfirmationDialog extends StatelessWidget {
  const CustomConfirmationDialog({
    required this.confirmText,
    required this.onConfirm,
    this.message,
    this.content,
    super.key,
    this.title,
    this.cancelText = AppStrings.cancel,
    this.onCancel,
    this.isDestructive = false,
    this.showCancelButton = true,
  }) : assert(
         message != null || content != null,
         'Either message or content must be provided',
       );

  final String? title;
  final String? message;
  final Widget? content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool showCancelButton;

  static Future<void> show(
    BuildContext context, {
    required String confirmText,
    required VoidCallback onConfirm,
    String? title,
    String? message,
    Widget? content,
    String cancelText = AppStrings.cancel,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool showCancelButton = true,
  }) {
    return showCustomDialog<void>(
      context: context,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: CustomConfirmationDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
        showCancelButton: showCancelButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppTextStyles.font18W700White(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v16.r(context)),
          ],
          if (content != null) ...[
            content!,
            SizedBox(height: AppSpacing.v24.r(context)),
          ] else if (message != null) ...[
            Text(
              message!,
              style: AppTextStyles.font16W500Grey(
                context,
              ).copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v24.r(context)),
          ],
          Row(
            children: [
              if (showCancelButton) ...[
                Expanded(
                  child: AppSecondaryButton(
                    text: cancelText,
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCancel != null) onCancel?.call();
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.v12.r(context)),
              ],
              Expanded(
                child: AppPrimaryButton(
                  text: confirmText,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  backgroundColor: isDestructive
                      ? AppColors.red.withValues(alpha: 0.8)
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
