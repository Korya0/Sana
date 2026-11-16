import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/navigation/main_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/core/widgets/views/settings_view.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart';
import 'package:sana/features/azkar/presentation/views/custom_azkar_list_view.dart';
import 'package:sana/features/azkar/presentation/views/custom_zikr_form_view.dart';
import 'package:sana/features/azkar/presentation/views/tasbeeh_view.dart';
import 'package:sana/features/azkar/presentation/views/zikr_list_view.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.homePath,
    errorBuilder: (context, state) => Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                message: AppStrings.pageNotFound,
                onRetry: () => context.go(AppRoutes.homePath),
              ),
            ),
          ),
        ],
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashPath,
        builder: (context, state) => const Scaffold(),
      ),

      // Azkar reader — full screen above the shell
      GoRoute(
        path: AppRoutes.azkarCategoryPath,
        name: AppRoutes.azkarCategoryPath,
        builder: (context, state) {
          final categoryKey =
              state.pathParameters[AppRoutes.categoryKeyParam] ?? '';
          final extra = state.extra;
          final categoryTitle = extra is String
              ? extra
              : AppStrings.azkarHeader;

          return ZikrListView(
            categoryKey: categoryKey,
            categoryTitle: categoryTitle,
          );
        },
      ),

      // Custom zikr form — full screen above the shell
      GoRoute(
        path: AppRoutes.customZikrFormPath,
        name: AppRoutes.customZikrFormPath,
        builder: (context, state) {
          final extra = state.extra;
          final initialCategory = extra is CustomCategoryEntity ? extra : null;
          return CustomZikrFormView(initialCategory: initialCategory);
        },
      ),

      // Custom azkar list — full screen above the shell
      GoRoute(
        path: AppRoutes.customAzkarListPath,
        name: AppRoutes.customAzkarListPath,
        builder: (context, state) => const CustomAzkarListView(),
      ),

      // Tasbeeh — full screen above the shell
      GoRoute(
        path: AppRoutes.tasbeehPath,
        name: AppRoutes.tasbeehPath,
        builder: (context, state) {
          final extra = state.extra;
          final selectedId = extra is String ? extra : null;
          return TasbeehView(initialSelectedId: selectedId);
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainView(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homePath,
                name: AppRoutes.homePath,
                builder: (context, state) => const Scaffold(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.adhkarPath,
                name: AppRoutes.adhkarPath,
                builder: (context, state) => const AzkarTasbeehHomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.quranPath,
                name: AppRoutes.quranPath,
                builder: (context, state) => const Scaffold(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settingsPath,
                name: AppRoutes.settingsPath,
                builder: (context, state) => const SettingsView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
