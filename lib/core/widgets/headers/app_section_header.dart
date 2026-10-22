import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

/// Standard section heading: accent bar, title, and an optional trailing widget.
///
/// Use it instead of rebuilding the accent bar + title row:
/// ```dart
/// AppSectionHeader(
///   title: AppStrings.azkarHeader,
///   trailing: AppIconButton(...),
/// )
/// ```
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    super.key,
    this.trailing,
    this.padding,
  });

  final String title;

  /// Optional widget placed at the far end of the header.
  final Widget? trailing;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.p16),
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
