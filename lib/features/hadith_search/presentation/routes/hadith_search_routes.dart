import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/hadith_search/presentation/views/hadith_favorites_view.dart';
import 'package:sana/features/hadith_search/presentation/views/hadith_search_view.dart';

class HadithSearchRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.hadithSearch,
      name: AppRoutes.hadithSearch,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: BlocProvider(
          create: (context) => sl<HadithCubit>(),
          child: const HadithSearchView(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.hadithFavorites,
      name: AppRoutes.hadithFavorites,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: const HadithFavoritesView(),
      ),
    ),
  ];
}
