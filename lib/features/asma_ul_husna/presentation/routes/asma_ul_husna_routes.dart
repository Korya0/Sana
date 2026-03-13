import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/asma_ul_husna/presentation/views/asma_ul_husna_page.dart';

class AsmaUlHusnaRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.asmaUlHusna,
      name: AppRoutes.asmaUlHusna,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: const AsmaUlHusnaPage(),
      ),
    ),
  ];
}
