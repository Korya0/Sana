import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/developer_dashboard/presentation/controller/dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/views/developer_dashboard_view.dart';

class DeveloperDashboardRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.developerDashboard,
      name: AppRoutes.developerDashboard,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: BlocProvider(
          create: (context) {
            final cubit = sl<DashboardCubit>();
            unawaited(cubit.getFeedbacks());
            return cubit;
          },
          child: const DeveloperDashboardView(),
        ),
      ),
    ),
  ];
}
