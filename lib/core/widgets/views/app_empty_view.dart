import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.title = AppStrings.emptyTitle,
    this.message,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(AppSize.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            AppIcons.empty,
            size: AppSize.icon48,
            color: context.color.iconSecondary,
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
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14W500Secondary(context),
            ),
          ],
        ],
      ),
    ),
  );
}
