import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_scaffold.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qibla_widget.dart';

final List<RouteBase> qiblaRoutes = [
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
];
