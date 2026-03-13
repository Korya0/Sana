import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/teaching_prayer/presentation/controller/teaching_prayer_cubit.dart';
import 'package:sana/features/teaching_prayer/presentation/views/teaching_prayer_view.dart';

class TeachingPrayerRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.teachingPrayer,
      name: AppRoutes.teachingPrayer,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: BlocProvider(
          create: (context) => sl<TeachingPrayerCubit>(),
          child: const TeachingPrayerView(),
        ),
      ),
    ),
  ];
}
