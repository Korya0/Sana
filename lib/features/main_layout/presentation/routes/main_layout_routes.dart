
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/home/presentation/views/home_view.dart';
import 'package:sana/features/main_layout/presentation/views/main_layout_view.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/quran/presentation/views/quran_view.dart';
import 'package:sana/features/settings/presentation/views/settings_view.dart';

final List<RouteBase> mainLayoutRoutes = [
  StatefulShellRoute.indexedStack(
    pageBuilder: (context, state, navigationShell) {
      return AppTransitions.fade(
        context: context,
        state: state,
        child: MainLayoutView(navigationShell: navigationShell),
      );
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.home,
            pageBuilder: (context, state) => AppTransitions.fade(
              context: context,
              state: state,
              child: const HomeView(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.quran,
            name: AppRoutes.quran,
            pageBuilder: (context, state) => AppTransitions.fade(
              context: context,
              state: state,
              child: BlocProvider(
                create: (_) => sl<QuranCubit>(),
                child: const QuranView(),
              ),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.settings,
            name: AppRoutes.settings,
            pageBuilder: (context, state) => AppTransitions.fade(
              context: context,
              state: state,
              child: const SettingsView(),
            ),
          ),
        ],
      ),
    ],
  ),
];
