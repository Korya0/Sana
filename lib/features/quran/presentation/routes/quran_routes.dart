import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/quran/presentation/views/quran_view.dart';

class QuranRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.quran,
      name: AppRoutes.quran,
      pageBuilder: (context, state) => AppTransitions.fade(
        context: context,
        state: state,
        child: const QuranView(),
      ),
    ),
  ];
}
