import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qiblaview.dart';

class QiblaRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.qibla,
      name: AppRoutes.qibla,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: const LocationGuard(
          showCountryOption: false,
          forceGPS: true,
          loadingPlaceholder: SkeletonizerQiblaview(),
          child: QiblaView(),
        ),
      ),
    ),
  ];
}
