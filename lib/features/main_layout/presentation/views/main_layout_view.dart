import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.color.secondaryScaffoldBackgroundColor,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => _onTap(context, index),
            backgroundColor: Colors.transparent,
            selectedItemColor: context.color.primary,
            unselectedItemColor: context.color.textPrimary.withValues(
              alpha: 0.5,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: AppTextStyles.font12W700(context)
                .copyWith(color: context.color.textPrimary)
                .copyWith(
                  color: context.color.primary,
                ),
            unselectedLabelStyle: AppTextStyles.font12W500(
              context,
            ).copyWith(color: context.color.textSecondary),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(SolarIconsBold.home),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(SolarIconsBold.home),
                ),
                label: AppStrings.home,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(SolarIconsBold.book),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(SolarIconsBold.book),
                ),
                label: AppStrings.quranKareem,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(SolarIconsBold.settings),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(SolarIconsBold.settings),
                ),
                label: AppStrings.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
