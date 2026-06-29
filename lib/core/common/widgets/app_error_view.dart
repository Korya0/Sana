import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

/// A generic error view used across the app to display error messages and retry actions.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    this.message,
    this.onRetry,
  });

  /// The error message to display.
  final String? message;

  /// The callback to execute when the retry button is pressed.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.v18,
          vertical: AppSpacing.v18,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              AppStrings.errorWidgetTitle,
              style: AppTextStyles.font20W700(context).copyWith(color: context.color.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.v18),

            // Message
            if (message != null)
              Text(
                message!,
                style: AppTextStyles.font16W500(context).copyWith(color: context.color.textSecondary).copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.v18 * 2),
              AppPrimaryButton(
                text: AppStrings.tryAgain,
                icon: SolarIconsBold.refresh,
                onPressed: onRetry!,
                // We keep it full width by default or can set it to null for wrap content
                width: 200.r(context), // Reasonable fixed width for error buttons
              ),
            ],
          ],
        ),
      ),
    );
  }
}
