import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/not_found_view.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/analytics/analytics_service.dart';

import 'package:sana/features/asma_ul_husna/presentation/routes/asma_ul_husna_routes.dart';
import 'package:sana/features/azkar/presentation/routes/azkar_routes.dart';
import 'package:sana/features/daily_content/presentation/routes/daily_content_routes.dart';
import 'package:sana/features/developer_dashboard/presentation/routes/developer_dashboard_routes.dart';
import 'package:sana/features/feedback/presentation/routes/feedback_routes.dart';
import 'package:sana/features/main_layout/presentation/routes/main_layout_routes.dart';
import 'package:sana/features/prayer/presentation/routes/prayer_routes.dart';
import 'package:sana/features/qibla/presentation/routes/qibla_routes.dart';
import 'package:sana/features/salat_ala_nabi/presentation/routes/salat_ala_nabi_routes.dart';
import 'package:sana/features/splash/presentation/routes/splash_routes.dart';
import 'package:sana/features/teaching_prayer/presentation/routes/teaching_prayer_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    observers: [sl<IAnalyticsService>().getObserver()],
    initialLocation: AppRoutes.splash,
    errorBuilder: (context, state) => const NotFoundView(),
    routes: [
      ...splashRoutes,
      ...mainLayoutRoutes,
      ...azkarRoutes,
      ...qiblaRoutes,
      ...feedbackRoutes,
      ...salatAlaNabiRoutes,
      ...asmaUlHusnaRoutes,
      ...prayerRoutes,
      ...teachingPrayerRoutes,
      ...dailyContentRoutes,
      ...developerDashboardRoutes,
    ],
  );
}
