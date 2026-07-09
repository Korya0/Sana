import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/custom_arrow_back_button.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';

class CommonSliverAppBar extends StatelessWidget {
  const CommonSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onBackPressed,
    this.actions,
    this.bottom,
    this.hasBackButton = true,
  }) : assert(
         title == null || titleWidget == null,
         'Cannot provide both a title and a titleWidget.',
       );

  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool hasBackButton;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.color.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      leading: hasBackButton
          ? CustomArrowBackButton(onTap: onBackPressed)
          : null,
      title:
          titleWidget ??
          Text(
            title ?? '',
            style: AppTextStyles.font14W700(
              context,
            ).copyWith(color: context.color.textPrimary),
          ),
      centerTitle: true,
      actionsPadding: const EdgeInsets.only(left: AppSpacing.v18),
      actions: actions != null ? [Row(children: actions!)] : null,
      bottom: bottom,
    );
  }
}
