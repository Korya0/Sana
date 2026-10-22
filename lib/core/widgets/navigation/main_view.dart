import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_navigation_guard.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:sana/core/widgets/navigation/bottom_nav_tab_config.dart';

const List<BottomNavTabConfig> mainBottomNavTabs = [
  BottomNavTabConfig(label: AppStrings.homeTab, icon: AppIcons.home),
  BottomNavTabConfig(label: AppStrings.adhkarTab, icon: AppIcons.adhkar),
  BottomNavTabConfig(label: AppStrings.quranTab, icon: AppIcons.quran),
  BottomNavTabConfig(label: AppStrings.settingsTab, icon: AppIcons.settings),
];

class MainView extends StatelessWidget {
  const MainView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: navigationShell.currentIndex == 0,
    onPopInvokedWithResult: (didPop, _) {
      if (didPop) return;
      AppNavigationGuard.runTransient(
        () => navigationShell.goBranch(0, initialLocation: true),
      );
    },
    child: Scaffold(
      // Body
      body: navigationShell,

      // Bottom navigation
      bottomNavigationBar: AppBottomNavBar(
        tabs: mainBottomNavTabs,
        currentIndex: navigationShell.currentIndex,
        onTabSelected: (index) => AppNavigationGuard.runTransient(
          () => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        ),
      ),
    ),
  );
}
