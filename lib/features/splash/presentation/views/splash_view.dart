import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sana/core/bootstrap/heavy_services_bootstrapper.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_background_executor.dart';
import 'package:sana/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:sana/features/splash/presentation/cubit/splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = SplashCubit();
        unawaited(cubit.startSplash());
        return cubit;
      },
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashFinished) {
            AppNavigator.goNamed(context, AppRoutes.home);
            HeavyServicesBootstrapper(
              notificationService: sl<INotificationService>(),
              workManagerService: sl<IWorkManagerService>(),
              remoteConfig: sl(),
              salawatCallbackDispatcher: salawatCallbackDispatcher,
            ).setupNotificationTapHandler();
          }
        },
        child: const Scaffold(
          body: Center(child: _Logo()),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
          context.image.appLogo,
          width: AppSpacing.w200.r(context),
        )
        .animate()
        .fadeIn(
          duration: 1500.ms,
          curve: Curves.easeInOut,
        )
        .scale(
          begin: const Offset(0.4, 0.4),
          end: const Offset(1, 1),
          duration: 1500.ms,
          curve: Curves.easeInOut,
        );
  }
}
