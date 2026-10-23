import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    super.key,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: AppSize.p16),
    child: Row(
      children: [
        // Accent bar
        Container(
          width: AppSize.w4,
          height: AppSize.h18,
          decoration: BoxDecoration(
            color: context.color.primary,
            borderRadius: BorderRadius.circular(AppSize.r4),
          ),
        ),
        AppGap.w(AppSize.p8),

        // Title
        Expanded(
          child: Text(
            title,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16W700Primary(context),
          ),
        ),

        // Optional trailing action on the opposite side.
        if (trailing != null) ...[
          AppGap.w(AppSize.p8),
          trailing!,
        ],
      ],
    ),
  );
}
