import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    errorBuilder: (context, state) => const Scaffold(),
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashPath,
        builder: (context, state) => const Scaffold(),
      ),
    ],
  );
}
