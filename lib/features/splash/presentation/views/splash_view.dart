import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/core/utils/utils.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LocationGuard(
        showCancelButton: false,
        onClose: SystemNavigator.pop,
        onInit: (context) async {
          await context.read<LocationCubit>().checkLocationStatus();
        },
        loadingPlaceholder: const Center(child: _Logo()),
        child: const _NavigateToHome(),
      ),
    );
  }
}

class _NavigateToHome extends StatefulWidget {
  const _NavigateToHome();

  @override
  State<_NavigateToHome> createState() => _NavigateToHomeState();
}

class _NavigateToHomeState extends State<_NavigateToHome> {
  @override
  void initState() {
    super.initState();
    unawaited(_navigateToHome());
  }

  Future<void> _navigateToHome() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.goNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: _Logo());
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          SvgPicture.asset(
                context.image.appLogo,
                width: 200.r(context),
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
              ),
    );
  }
}
