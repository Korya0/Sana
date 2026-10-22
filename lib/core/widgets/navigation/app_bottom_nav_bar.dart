import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/navigation/bottom_nav_tab_config.dart';

import '../app_gap.dart' show AppGap;
import '../interaction/app_pressable.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
  });

  final List<BottomNavTabConfig> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.secondaryScaffoldBackgroundColor,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.all(AppSize.p8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.color.dividerColor,
                width: AppSize.borderWidth,
              ),
            ),
          ),
          child: Row(
            children: [
              for (var index = 0; index < tabs.length; index++)
                Expanded(
                  child: _NavItemWidget(
                    tab: tabs[index],
                    isActive: index == currentIndex,
                    onTap: () => onTabSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final BottomNavTabConfig tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? context.color.iconBrand
        : context.color.iconSecondary;

    // Item (icon + label)
    return AppPressable(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(tab.icon, size: AppSize.icon24, color: color),

          // Label
          AppGap.h(AppSize.p4),
          Text(
            tab.label,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: isActive
                ? AppTextStyles.font12W700Brand(context)
                : AppTextStyles.font12W500Secondary(context),
          ),
        ],
      ),
    );
  }
}
