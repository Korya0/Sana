import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';

class CommonSliverAppBar extends StatelessWidget {
  const CommonSliverAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions,
    this.hasBackButton = true,
    this.isPinned = false,
  });

  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool hasBackButton;
  final bool isPinned;

  @override
  Widget build(BuildContext context) => SliverAppBar(
    backgroundColor: context.color.scaffoldBackgroundColor,
    elevation: AppConstants.elevationNone,
    scrolledUnderElevation: AppConstants.elevationNone,
    floating: !isPinned,
    snap: !isPinned,
    pinned: isPinned,
    automaticallyImplyLeading: false,
    leading: hasBackButton
        ? Center(
            child: AppIconButton(
              icon: AppIcons.back,
              tooltip: AppStrings.back,
              onPressed:
                  onBackPressed ?? () => Navigator.of(context).maybePop(),
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
