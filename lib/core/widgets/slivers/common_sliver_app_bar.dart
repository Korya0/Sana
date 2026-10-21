import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';

class CommonSliverAppBar extends StatelessWidget {
  const CommonSliverAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions,
    this.hasBackButton = true,
  });

  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool hasBackButton;

  @override
  Widget build(BuildContext context) => SliverAppBar(
    backgroundColor: context.color.scaffoldBackgroundColor,
    elevation: AppConstants.elevationNone,
    scrolledUnderElevation: AppConstants.elevationNone,
    floating: true,
    snap: true,
    automaticallyImplyLeading: false,
    leading: hasBackButton
        ? IconButton(
            onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
            tooltip: AppStrings.back,
            icon: Icon(
              AppIcons.back,
              size: AppSize.icon24,
              color: context.color.textPrimary,
            ),
          )
        : null,
    title: title == null
        ? null
        : Text(
            title!,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16W700Primary(context),
          ),
    centerTitle: true,
    actions: actions,
  );
}
