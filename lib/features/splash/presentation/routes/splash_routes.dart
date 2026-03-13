import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/splash/presentation/views/splash_view.dart';

class SplashRoutes {
  static final List<RouteBase> routes = [
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
}
