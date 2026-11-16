import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.icon,
    required this.title,
    super.key,
    this.iconColor,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final Color? iconColor;
  final String? message;
  final Widget? action;

  // Builds state
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(AppSize.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            size: AppSize.icon48,
            color: iconColor ?? context.color.iconSecondary,
          ),
          AppGap.h(AppSize.p16),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16W700Primary(context),
          ),
          if (message != null) ...[
            AppGap.h(AppSize.p8),

            // Message
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14W500Secondary(context),
            ),
          ],
          if (action != null) ...[
            AppGap.h(AppSize.p24),

            // Action
            action!,
          ],
        ],
      ),
    ),
  );
}
