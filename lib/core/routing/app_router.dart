import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/asma_ul_husna/presentation/routes/asma_ul_husna_routes.dart';
import 'package:sana/features/azkar/presentation/routes/azkar_routes.dart';
import 'package:sana/features/daily_content/presentation/routes/daily_content_routes.dart';
import 'package:sana/features/developer_dashboard/presentation/routes/developer_dashboard_routes.dart';
import 'package:sana/features/feedback/presentation/routes/feedback_routes.dart';
import 'package:sana/features/hadith_search/presentation/routes/hadith_search_routes.dart';
import 'package:sana/features/home/presentation/routes/home_routes.dart';
import 'package:sana/features/prayer/presentation/routes/prayer_routes.dart';
import 'package:sana/features/qibla/presentation/routes/qibla_routes.dart';
import 'package:sana/features/quran/presentation/routes/quran_routes.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/routes/salat_ala_nabi_routes.dart';
import 'package:sana/features/splash/presentation/routes/splash_routes.dart';
import 'package:sana/features/teaching_prayer/presentation/routes/teaching_prayer_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      ...SplashRoutes.routes,
      ...HomeRoutes.routes,
      ...QuranRoutes.routes,
      ...AzkarRoutes.routes,
      ...QiblaRoutes.routes,
      ...FeedbackRoutes.routes,
      ...SalatAlaNabiRoutes.routes,
      ...AsmaUlHusnaRoutes.routes,
      ...PrayerRoutes.routes,
      ...TeachingPrayerRoutes.routes,
      ...DailyContentRoutes.routes,
      ...HadithSearchRoutes.routes,
      ...DeveloperDashboardRoutes.routes,
    ],
  );
}
