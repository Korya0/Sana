import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/quran/presentation/views/quran_view.dart';

class QuranRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.quran,
      name: AppRoutes.quran,
      pageBuilder: (context, state) => AppTransitions.fade(
        context: context,
        state: state,
        child: BlocProvider(
          create: (_) => sl<QuranCubit>(),
          child: const QuranView(),
        ),
      ),
    ),
  ];
}
