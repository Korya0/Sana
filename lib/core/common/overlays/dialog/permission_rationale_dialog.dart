import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';

/// Shows a permission rationale dialog before requesting a system permission.
///
/// This gives the user context about why the permission is needed,
/// making the request less surprising and more likely to be granted.
///
/// Returns `true` if the user confirmed, `false` if cancelled.
Future<bool> showPermissionRationaleDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? iconAsset,
  String? confirmText,
  String? cancelText,
}) async {
  final result = await showCustomDialog<bool>(
    context: context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        if (iconAsset != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.v16),
            child: Center(
              child: Image.asset(
                iconAsset,
                width: AppSpacing.v48,
                height: AppSpacing.v48,
                color: context.color.primary,
              ),
            ),
          ),
        // Title
        Text(
          title,
          style: AppTextStyles.font20W700(context),
          textAlign: TextAlign.center,
        ),
        const AppGap.h(AppSpacing.v12),
        // Message
        Text(
          message,
          style: AppTextStyles.font14W500(context)
              .copyWith(color: context.color.textSecondary),
          textAlign: TextAlign.center,
        ),
        const AppGap.h(AppSpacing.v24),
        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: AppSecondaryButton(
                text: cancelText ?? AppStrings.cancel,
                onPressed: () => AppNavigator.pop(context, false),
              ),
            ),
            const AppGap.w(AppSpacing.v12),
            Expanded(
              child: AppPrimaryButton(
                text: confirmText ?? AppStrings.allow,
                onPressed: () => AppNavigator.pop(context, true),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return result ?? false;
}
