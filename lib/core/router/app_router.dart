import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_route_observer.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/router/features/azkar_tasbeeh_router.dart';
import 'package:sana/core/widgets/navigation/main_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/core/widgets/views/settings_view.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.homeView,
    observers: [AppRouteObserver.instance],

    // Not found
    errorBuilder: (context, state) => Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                message: AppStrings.pageNotFound,
                onRetry: () => context.go(AppRoutes.homeView),
              ),
            ),
          ),
        ],
      ),
    ),
    routes: [
      // Azkar tasbeeh feature
      ...azkarTasbeehRoutes,

      // Qibla routes
      GoRoute(
        path: AppRoutes.qiblaView,
        name: AppRoutes.qiblaView,
        builder: (context, state) => const QiblaView(),
      ),

      // Main shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainView(navigationShell: navigationShell),
        branches: [
          // Home tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homeView,
                name: AppRoutes.homeView,
                builder: (context, state) => const Scaffold(),
              ),
            ],
          ),

          // Azkar tasbeeh tab
          StatefulShellBranch(routes: [azkarTasbeehTabRoute]),

          // Quran tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.quranView,
                name: AppRoutes.quranView,
                builder: (context, state) => const Scaffold(),
              ),
            ],
          ),

          // Settings tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settingsView,
                name: AppRoutes.settingsView,
                builder: (context, state) => const SettingsView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
