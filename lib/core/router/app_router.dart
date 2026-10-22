import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_navigator.dart';
import 'package:sana/core/router/app_navigator_observer.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/navigation/main_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_categories_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.homePath,
    observers: [AppNavigatorObserver()],
    errorBuilder: (context, state) => Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                message: AppStrings.pageNotFound,
                onRetry: () => AppNavigator.go(context, AppRoutes.homePath),
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
          final categoryId =
              int.tryParse(
                state.pathParameters[AppRoutes.categoryIdParam] ?? '',
              ) ??
              0;
          final extra = state.extra;
          final categoryTitle = extra is String
              ? extra
              : AppStrings.azkarHeader;

          return AzkarListView(
            categoryId: categoryId,
            categoryTitle: categoryTitle,
          );
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
                builder: (context, state) => const AzkarCategoriesView(),
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
                builder: (context, state) => const Scaffold(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
