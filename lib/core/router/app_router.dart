import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/navigation/main_view.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.homePath,
    errorBuilder: (context, state) => const Scaffold(),
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashPath,
        builder: (context, state) => const Scaffold(),
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
                builder: (context, state) => const Scaffold(),
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
