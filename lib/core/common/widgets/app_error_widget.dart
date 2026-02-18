import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:solar_icons/solar_icons.dart';

class AppErrorWidget extends StatelessWidget {
  final String title;
  final String? message;
  final String? technicalMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onReport;

  const AppErrorWidget({
    super.key,
    required this.title,
    this.message,
    this.technicalMessage,
    this.onRetry,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.horizontalP18,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              title,
              style: AppTextStyles.font18W700White(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.betweenSections18),

            // Message
            if (message != null)
              Text(
                message!,
                style: AppTextStyles.font16W500Grey(context),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: AppSpacing.betweenSections18 * 2),

            // Retry Button (if provided)
            if (onRetry != null)
              AppPrimaryButton(
                text: 'حاول مرة أخرى',
                icon: SolarIconsBold.refresh,
                onPressed: onRetry!,
              ),

            // Report Button
            if (onReport != null || technicalMessage != null) ...[
              const SizedBox(height: (12)),
              AppSecondaryButton(
                text: 'الإبلاغ عن المشكلة',
                icon: SolarIconsBold.letter,
                onPressed:
                    onReport ??
                    () {
                      context.push(
                        Uri(
                          path: AppRoutes.report,
                          queryParameters: {
                            AppRoutes.errorDetailsKey: technicalMessage,
                          },
                        ).toString(),
                      );
                    },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
