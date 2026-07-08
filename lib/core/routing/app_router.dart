import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/analytics/analytics_service.dart';

import 'package:sana/core/routing/asma_ul_husna_routes.dart';
import 'package:sana/core/routing/daily_content_routes.dart';
import 'package:sana/core/routing/developer_dashboard_routes.dart';
import 'package:sana/core/routing/feedback_routes.dart';
import 'package:sana/core/routing/main_layout_routes.dart';
import 'package:sana/core/routing/prayer_routes.dart';
import 'package:sana/core/routing/qibla_routes.dart';
import 'package:sana/core/routing/salat_ala_nabi_routes.dart';
import 'package:sana/core/routing/splash_routes.dart';
import 'package:sana/core/routing/teaching_prayer_routes.dart';
import 'package:sana/core/routing/azkar_routes.dart';

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
      ...qiblaRoutes,
      ...feedbackRoutes,
      ...salatAlaNabiRoutes,
      ...asmaUlHusnaRoutes,
      ...prayerRoutes,
      ...teachingPrayerRoutes,
      ...dailyContentRoutes,
      ...developerDashboardRoutes,
      ...azkarRoutes,
    ],
  );
}
