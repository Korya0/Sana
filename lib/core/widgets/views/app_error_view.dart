import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(AppSize.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            AppIcons.error,
            size: AppSize.icon48,
            color: context.color.iconSecondary,
          ),
          AppGap.h(AppSize.p16),

          // Title
          Text(
            AppStrings.errorWidgetTitle,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16W700Primary(context),
          ),
          AppGap.h(AppSize.p8),

          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14W500Secondary(context),
          ),
          if (onRetry != null) ...[
            AppGap.h(AppSize.p24),
            AppPrimaryButton(
              label: AppStrings.tryAgain,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    ),
  );
}
