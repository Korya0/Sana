import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/splash/presentation/pages/splash_view.dart';

final List<RouteBase> splashRoutes = [
  GoRoute(
    path: AppRoutes.splash,
    name: AppRoutes.splash,
    pageBuilder: (context, state) => AppTransitions.fade(
      context: context,
      state: state,
      child: const SplashView(),
    ),
  ),
];
