import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/not_found_view.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/core/services/analytics/analytics_service.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/features/asma_ul_husna/presentation/views/asma_ul_husna_view.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/views/azkar_details_loader_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/views/daily_content_favorites_view.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/views/developer_dashboard_view.dart';
import 'package:sana/features/feedback/presentation/views/feedback_issue_view.dart';
import 'package:sana/features/home/presentation/views/home_view.dart';
import 'package:sana/features/main_layout/presentation/views/main_layout_view.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/views/prayer_times_settings_view.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_scaffold.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qibla_widget.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/quran/presentation/views/quran_view.dart';
import 'package:sana/features/salat_ala_nabi/presentation/views/salat_ala_nabi_view.dart';
import 'package:sana/features/settings/presentation/views/settings_view.dart';
import 'package:sana/features/splash/presentation/views/splash_view.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';
import 'package:sana/features/teaching_prayer/presentation/views/teaching_prayer_view.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    observers: [sl<IAnalyticsService>().getObserver()],
    initialLocation: AppRoutes.splash,
    errorBuilder: (context, state) => const NotFoundView(),
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const SplashView(),
        ),
      ),
      // Main Layout Shell
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return AppTransitions.fade(
            context: context,
            state: state,
            child: MainLayoutView(navigationShell: navigationShell),
          );
        },
        branches: [
          // Home Branch
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
          // Quran Branch
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
          // Settings Branch
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
      // Azkar
      GoRoute(
        path: AppRoutes.azkar,
        name: AppRoutes.azkar,
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters[AppRoutes.categoryIdKey];
          final extra = state.extra;

          Widget child;
          if (extra is AzkarCategoryModel) {
            child = AzkarListView(category: extra);
          } else {
            child = AzkarDetailsLoaderView(categoryId: categoryId ?? '');
          }

          return AppTransitions.slideFromRight(
            context: context,
            state: state,
            child: child,
          );
        },
      ),

      // Qibla
      GoRoute(
        path: AppRoutes.qibla,
        name: AppRoutes.qibla,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const LocationGuard(
            showCountryOption: false,
            forceGPS: true,
            loadingPlaceholder: QiblaScaffold(body: SkeletonizerQiblaWidget()),
            child: QiblaView(),
          ),
        ),
      ),
      // Feedback
      GoRoute(
        path: AppRoutes.feedback,
        name: AppRoutes.feedback,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const FeedbackIssueView(),
        ),
      ),
      // SalatAla Nabi
      GoRoute(
        path: AppRoutes.salatAlaNabi,
        name: AppRoutes.salatAlaNabi,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const SalatAlaNabiView(),
        ),
      ),
      // Asma Ul Husna
      GoRoute(
        path: AppRoutes.asmaUlHusna,
        name: AppRoutes.asmaUlHusna,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const AsmaUlHusnaView(),
        ),
      ),
      // Prayer
      GoRoute(
        path: AppRoutes.prayerSettings,
        name: AppRoutes.prayerSettings,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<LocationNameCubit>()),
              BlocProvider.value(value: sl<AppDateCubit>()),
              BlocProvider.value(value: sl<PrayerTimesCubit>()),
            ],
            child: const LocationGuard(
              enforceOnInit: false,
              child: PrayerTimesSettingsView(),
            ),
          ),
        ),
      ),
      // Teaching Prayer
      GoRoute(
        path: AppRoutes.teachingPrayer,
        name: AppRoutes.teachingPrayer,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) {
              final cubit = sl<TeachingPrayerCubit>();
              unawaited(cubit.loadSections());
              return cubit;
            },
            child: const TeachingPrayerView(),
          ),
        ),
      ),
      // Daily Content
      GoRoute(
        path: AppRoutes.dailyContentFavorites,
        name: AppRoutes.dailyContentFavorites,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: BlocProvider.value(
            value: sl<DailyContentCubit>(),
            child: const DailyContentFavoritesView(),
          ),
        ),
      ),
      // Developer Dashboard
      GoRoute(
        path: AppRoutes.developerDashboard,
        name: AppRoutes.developerDashboard,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) {
              final cubit = sl<DashboardCubit>();
              unawaited(cubit.getFeedbacks());
              return cubit;
            },
            child: const DeveloperDashboardView(),
          ),
        ),
      ),
    ],
  );
}
