import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/daily_content/presentation/views/daily_content_favorites_view.dart';

class DailyContentRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.dailyContentFavorites,
      name: AppRoutes.dailyContentFavorites,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: const DailyContentFavoritesView(),
      ),
    ),
  ];
}
