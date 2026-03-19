import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/location_manager/presentation/controller/location_name/location_name_cubit.dart';
import 'package:sana/features/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/features/prayer/presentation/views/prayer_times_settings_view.dart';

class PrayerRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.prayerSettings,
      name: AppRoutes.prayerSettings,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => sl<LocationNameCubit>(),
          child: const LocationGuard(
            enforceOnInit: false,
            child: PrayerTimesSettingsView(),
          ),
        ),
      ),
    ),
  ];
}
