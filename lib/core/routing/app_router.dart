import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/location_guard.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';
import 'package:sana/features/azkar/presentation/views/all_azkar_categories_view.dart';
import 'package:sana/features/home/presentation/views/home_view.dart';
import 'package:sana/features/prayer/presentation/views/prayer_times_settings_view.dart';

import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qiblaview.dart';
import 'package:sana/features/quran/presentation/views/quran_view.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/views/salat_ala_nabi_view.dart';
import 'package:sana/features/report/presentation/views/report_issue_view.dart';
import 'package:sana/features/splash/presentation/views/splash_view.dart';
import 'package:sana/features/settings/presentation/views/settings_view.dart';
import 'package:sana/features/asma_ul_husna/presentation/pages/asma_ul_husna_page.dart';
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
          child: SplashView(),
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
          final category = state.extra as AzkarCategoryModel;
          return AppTransitions.slideFromLeft(
            context: context,
            state: state,
            child: AzkarListView(category: category),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.qibla,
        name: AppRoutes.qibla,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: LocationGuard(
            loadingPlaceholder: SkeletonizerQiblaview(),
            child: const QiblaView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.report,
        name: AppRoutes.report,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final errorDetails = extra?['errorDetails'] as String?;
          final isSuggestion = extra?['isSuggestion'] as bool? ?? false;

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
        pageBuilder: (context, state) => AppTransitions.slideFromBottom(
          context: context,
          state: state,
          child: const SalatAlaNabiView(),
        ),
      ),

      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settings,
        pageBuilder: (context, state) => AppTransitions.slideFromLeft(
          context: context,
          state: state,
          child: const SettingsView(),
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
          child: const AllAzkarCategoriesView(),
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
    ],
  );
}
