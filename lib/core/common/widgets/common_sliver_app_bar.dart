import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/custom_arrow_back_button.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class CommonSliverAppBar extends StatelessWidget {
  const CommonSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onBackPressed,
    this.actions,
  });
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      leading: onBackPressed != null
          ? CustomArrowBackButton(onTap: onBackPressed)
          : const CustomArrowBackButton(),
      title:
          titleWidget ??
          Text(title ?? '', style: AppTextStyles.font18W700White(context)),
      centerTitle: true,
      actionsPadding: const EdgeInsets.only(left: AppSpacing.horizontalP18),
      actions: actions != null ? [Row(children: actions!)] : null,
    );
  }
}
