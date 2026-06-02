import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.v16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80.r(context),
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.v24),
            Text(
              AppStrings.pageNotFound,
              textAlign: TextAlign.center,
              style: AppTextStyles.font20W700White(context),
            ),
            const SizedBox(height: AppSpacing.v16),
            Text(
              AppStrings.pageNotFoundDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16W500Grey(context),
            ),
            const SizedBox(height: AppSpacing.v40),

            AppPrimaryButton(
              onPressed: () => context.goNamed(AppRoutes.home),
              icon: Icons.home_rounded,
              text: AppStrings.backToHome,
            ),
            const SizedBox(height: AppSpacing.v16),

            AppSecondaryButton(
              onPressed: () => context.pushNamed(AppRoutes.feedback),
              icon: Icons.lightbulb_outline,
              text: AppStrings.feedbackTitle,
              borderColor: AppColors.textPrimary.withValues(alpha: 0.5),
              textColor: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

