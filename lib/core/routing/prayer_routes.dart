import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/views/prayer_times_settings_view.dart';

final List<RouteBase> prayerRoutes = [
  GoRoute(
    path: AppRoutes.prayerSettings,
    name: AppRoutes.prayerSettings,
    pageBuilder: (context, state) => AppTransitions.slideFromRight(
      context: context,
      state: state,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LocationNameCubit>()),
          BlocProvider.value(value: sl<AppDateCubit>()),
          BlocProvider.value(value: sl<PrayerTimesCubit>()),
        ],
        child: const LocationGuard(
          enforceOnInit: false,
          child: PrayerTimesSettingsView(),
        ),
      ),
    ),
  ),
];
