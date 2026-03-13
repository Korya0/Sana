import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/views/salat_ala_nabi_view.dart';

class SalatAlaNabiRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.salatAlaNabi,
      name: AppRoutes.salatAlaNabi,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: const SalatAlaNabiView(),
      ),
    ),
  ];
}
