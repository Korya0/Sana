import 'package:sana/core/routing/app_navigator.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/common/overlays/dialog/app_dialog.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';

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
    return AppDialog.show<void>(
      context: context,
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
              style: AppTextStyles.font20W700(context),
              textAlign: TextAlign.center,
            ),
            const AppGap.h(AppSpacing.v16),
          ],
          if (content != null) ...[
            content!,
            const AppGap.h(AppSpacing.v24),
          ] else if (message != null) ...[
            Text(
              message!,
              style: AppTextStyles.font16W500(context).copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const AppGap.h(AppSpacing.v24),
          ],
          Row(
            children: [
              if (showCancelButton) ...[
                Expanded(
                  child: AppSecondaryButton(
                    text: cancelText,
                    onPressed: () {
                      AppNavigator.pop(context);
                      if (onCancel != null) onCancel?.call();
                    },
                  ),
                ),
                const AppGap.w(AppSpacing.v12),
              ],
              Expanded(
                child: AppPrimaryButton(
                  text: confirmText,
                  onPressed: () {
                    AppNavigator.pop(context);
                    onConfirm();
                  },
                  backgroundColor: isDestructive
                      ? context.color.error.withValues(alpha: 0.8)
                      : context.color.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
