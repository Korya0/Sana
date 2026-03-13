import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/home/presentation/views/home_view.dart';

class HomeRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      pageBuilder: (context, state) => AppTransitions.fade(
        context: context,
        state: state,
        child: const HomeView(),
      ),
    ),
  ];
}
