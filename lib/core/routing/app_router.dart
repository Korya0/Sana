import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/location_guard.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/asma_ul_husna/presentation/views/asma_ul_husna_page.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/views/all_azkar_categories_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';
import 'package:sana/features/home/data/repositories/sortable_category_repository.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';
import 'package:sana/features/home/presentation/views/home_view.dart';
import 'package:sana/features/prayer/presentation/views/prayer_times_settings_view.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qiblaview.dart';
import 'package:sana/features/quran/presentation/views/quran_view.dart';
import 'package:sana/features/report/presentation/views/report_issue_view.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/views/salat_ala_nabi_view.dart';
import 'package:sana/features/daily_content/presentation/daily_content_favorites_view.dart';
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
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const QuranView(),
        ),
      ),

      GoRoute(
        path: AppRoutes.azkar,
        name: AppRoutes.azkar,
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters['categoryId'];
          final extra = state.extra;

          if (extra is AzkarCategoryModel) {
            return AppTransitions.slideFromLeft(
              context: context,
              state: state,
              child: AzkarListView(category: extra),
            );
          }

          return AppTransitions.fade(
            context: context,
            state: state,
            child: FutureBuilder<AzkarCategoryModel?>(
              future: sl<SortableCategoryRepository<AzkarCategoryModel>>()
                  .getItemById(categoryId ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return AzkarListView(category: snapshot.data!);
                }
                return const HomeView();
              },
            ),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.qibla,
        name: AppRoutes.qibla,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
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
          final errorDetails = state.uri.queryParameters['errorDetails'];
          final isSuggestion =
              state.uri.queryParameters['isSuggestion'] == 'true';

          return AppTransitions.slideFromLeft(
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
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: const SalatAlaNabiView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.asmaUlHusna,
        name: AppRoutes.asmaUlHusna,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: const AsmaUlHusnaPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.allAzkar,
        name: AppRoutes.allAzkar,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: BlocProvider(
            create: (context) =>
                sl<SortableCategoryCubit<AzkarCategoryModel>>()..loadFeatures(),
            child: const AllAzkarCategoriesView(),
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.prayerSettings,
        name: AppRoutes.prayerSettings,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: const PrayerTimesSettingsView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.teachingPrayer,
        name: AppRoutes.teachingPrayer,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: const TeachingPrayerView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.dailyContentFavorites,
        name: AppRoutes.dailyContentFavorites,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: const DailyContentFavoritesView(),
        ),
      ),
    ],
  );
}
