import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:solar_icons/solar_icons.dart';

/// A generic error widget used across the app to display error messages and retry actions.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
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
          horizontal: AppDesign.horizontalP18,
          vertical: AppDesign.betweenSections18,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              AppStrings.errorWidgetTitle,
              style: AppTextStyles.font18W700White(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesign.betweenSections18),

            // Message
            if (message != null)
              Text(
                message!,
                style: AppTextStyles.font16W500Grey(context).copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

            // Retry Button
            if (onRetry != null) ...[
              const SizedBox(height: AppDesign.betweenSections18 * 2),
              AppPrimaryButton(
                text: AppStrings.tryAgain,
                icon: SolarIconsBold.refresh,
                onPressed: onRetry!,
                // We keep it full width by default or can set it to null for wrap content
                width: 200, // Reasonable fixed width for error buttons
              ),
            ],
          ],
        ),
      ),
    );
  }
}
