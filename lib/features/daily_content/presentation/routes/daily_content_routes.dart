import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_favorites_cubit.dart';
import 'package:sana/features/daily_content/presentation/views/daily_content_favorites_view.dart';

final List<RouteBase> dailyContentRoutes = [
  GoRoute(
    path: AppRoutes.dailyContentFavorites,
    name: AppRoutes.dailyContentFavorites,
    pageBuilder: (context, state) => AppTransitions.slideFromRight(
      context: context,
      state: state,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<DailyContentCubit>()),
          BlocProvider(create: (_) => sl<DailyFavoritesCubit>()),
        ],
        child: const DailyContentFavoritesView(),
      ),
    ),
  ),
];
