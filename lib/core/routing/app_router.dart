import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/asma_ul_husna/presentation/views/asma_ul_husna_page.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/views/all_azkar_categories_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_details_loader_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';
import 'package:sana/features/daily_content/presentation/daily_content_favorites_view.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/developer_dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/views/developer_dashboard_view.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/hadith_search/presentation/views/hadith_favorites_view.dart';
import 'package:sana/features/hadith_search/presentation/views/hadith_search_view.dart';
import 'package:sana/features/home/presentation/views/home_view.dart';
import 'package:sana/features/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/features/prayer/presentation/views/prayer_times_settings_view.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qiblaview.dart';
import 'package:sana/features/quran/presentation/views/quran_view.dart';
import 'package:sana/features/report/presentation/views/report_issue_view.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/views/salat_ala_nabi_view.dart';
import 'package:sana/features/splash/presentation/views/splash_view.dart';
import 'package:sana/features/teaching_prayer/presentation/views/teaching_prayer_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const SplashView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const HomeView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.quran,
        name: AppRoutes.quran,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const QuranView(),
        ),
      ),

      GoRoute(
        path: AppRoutes.azkar,
        name: AppRoutes.azkar,
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters[AppRoutes.categoryIdKey];
          final extra = state.extra;

          // If we have the object passed directly (e.g. from Home), use it.
          if (extra is AzkarCategoryModel) {
            return AppTransitions.slideFromRight(
              context: context,
              state: state,
              child: AzkarListView(category: extra),
            );
          }

          // Otherwise (e.g. Deep Link), load it by ID.
          return AppTransitions.slideFromRight(
            context: context,
            state: state,
            child: AzkarDetailsLoaderView(categoryId: categoryId ?? ''),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.qibla,
        name: AppRoutes.qibla,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const LocationGuard(
            loadingPlaceholder: SkeletonizerQiblaview(),
            child: QiblaView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.report,
        name: AppRoutes.report,
        pageBuilder: (context, state) {
          final errorDetails =
              state.uri.queryParameters[AppRoutes.errorDetailsKey];
          final isSuggestion =
              state.uri.queryParameters[AppRoutes.isSuggestionKey] == 'true';

          return AppTransitions.slideFromRight(
            context: context,
            state: state,
            child: ReportIssueView(
              errorDetails: errorDetails,
              isSuggestion: isSuggestion,
            ),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.salatAlaNabi,
        name: AppRoutes.salatAlaNabi,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const SalatAlaNabiView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.asmaUlHusna,
        name: AppRoutes.asmaUlHusna,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const AsmaUlHusnaPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.allAzkar,
        name: AppRoutes.allAzkar,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => sl<AzkarCategoriesCubit>(),
            child: const AllAzkarCategoriesView(),
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.prayerSettings,
        name: AppRoutes.prayerSettings,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const PrayerTimesSettingsView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.teachingPrayer,
        name: AppRoutes.teachingPrayer,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const TeachingPrayerView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.dailyContentFavorites,
        name: AppRoutes.dailyContentFavorites,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const DailyContentFavoritesView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.hadithSearch,
        name: AppRoutes.hadithSearch,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<HadithCubit>()),
              BlocProvider(
                create: (context) => sl<HadithFavoritesCubit>(),
              ),
            ],
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
          child: BlocProvider(
            create: (context) => sl<HadithFavoritesCubit>(),
            child: const HadithFavoritesView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.developerDashboard,
        name: AppRoutes.developerDashboard,
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) => sl<DeveloperDashboardCubit>(),
            child: const DeveloperDashboardView(),
          ),
        ),
      ),
    ],
  );
}
