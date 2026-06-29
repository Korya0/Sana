import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/custom_arrow_back_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
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
  });

  /// The title text to display.
  final String? title;

  /// Custom widget for the title, takes precedence over [title].
  final Widget? titleWidget;

  /// Custom callback for the back button.
  final VoidCallback? onBackPressed;

  /// Actions displayed at the end of the AppBar.
  final List<Widget>? actions;

  /// Optional widget for the bottom of the AppBar.
  final PreferredSizeWidget? bottom;

  /// Whether to show a back button if leading is implicitly false.
  final bool hasBackButton;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            style: AppTextStyles.font20W700(
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
