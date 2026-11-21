import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/presentation/screens/zakat_calculate_screen.dart';
import 'package:sana/features/zakat/presentation/screens/zakat_explain_screen.dart';
import 'package:sana/features/zakat/presentation/screens/zakat_home_screen.dart';
import 'package:sana/features/zakat/presentation/screens/zakat_result_screen.dart';

/// Standalone routes for the Zakat feature (outside the shell).
final List<RouteBase> zakatRoutes = [
  GoRoute(
    path: AppRoutes.zakatHome,
    name: AppRoutes.zakatHome,
    builder: (context, state) => const ZakatHomeScreen(),
  ),
  GoRoute(
    path: AppRoutes.zakatCalculate,
    name: AppRoutes.zakatCalculate,
    builder: (context, state) => const ZakatCalculateScreen(),
  ),
  GoRoute(
    path: AppRoutes.zakatExplain,
    name: AppRoutes.zakatExplain,
    builder: (context, state) => const ZakatExplainScreen(),
  ),
  GoRoute(
    path: AppRoutes.zakatResult,
    name: AppRoutes.zakatResult,
    redirect: (context, state) {
      if (state.extra is ZakatResult) return null;
      return AppRoutes.zakatCalculate;
    },
    builder: (context, state) {
      final result = state.extra;
      if (result is! ZakatResult) return const ZakatCalculateScreen();
      return ZakatResultScreen(result: result);
    },
  ),
];
