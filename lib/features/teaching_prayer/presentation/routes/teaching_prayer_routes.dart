import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';
import 'package:sana/features/teaching_prayer/presentation/views/teaching_prayer_view.dart';

final List<RouteBase> teachingPrayerRoutes = [
  GoRoute(
    path: AppRoutes.teachingPrayer,
    name: AppRoutes.teachingPrayer,
    pageBuilder: (context, state) => AppTransitions.slideFromRight(
      context: context,
      state: state,
      child: BlocProvider(
        create: (context) {
          final cubit = sl<TeachingPrayerCubit>();
          unawaited(cubit.loadSections());
          return cubit;
        },
        child: const TeachingPrayerView(),
      ),
    ),
  ),
];
