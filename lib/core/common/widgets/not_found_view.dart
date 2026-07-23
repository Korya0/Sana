import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
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
              Icons.error_rounded,
              size: AppSpacing.s80.r(context),
              color: context.color.primary,
            ),
            const AppGap.h(AppSpacing.v24),
            Text(
              AppStrings.pageNotFound,
              textAlign: TextAlign.center,
              style: AppTextStyles.font20W700(
                context,
              ).copyWith(color: context.color.textPrimary),
            ),
            const AppGap.h(AppSpacing.v16),
            Text(
              AppStrings.pageNotFoundDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16W500(
                context,
              ).copyWith(color: context.color.textSecondary),
            ),
            const AppGap.h(AppSpacing.v40),

            AppPrimaryButton(
              onPressed: () => AppNavigator.goNamed(context, AppRoutes.home),
              icon: Icons.home_rounded,
              text: AppStrings.backToHome,
            ),
            const AppGap.h(AppSpacing.v16),

            AppSecondaryButton(
              onPressed: () => AppNavigator.pushNamed(context, AppRoutes.feedback),
              icon: Icons.lightbulb,
              text: AppStrings.feedbackTitle,
              borderColor: context.color.textPrimary.withValues(alpha: 0.5),
              textColor: context.color.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
