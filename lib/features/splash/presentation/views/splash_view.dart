import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/core/utils/context_extension.dart';

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
        loadingPlaceholder: const Center(child: Logo()),
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
    await Future<void>.delayed(const Duration(hours: 1));
    if (mounted) {
      context.goNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Logo());
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAnimations.fadeIn(
      Image.asset(
        context.image.appLogo,
        width: 200.r(context),
      ),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
    );
  }
}
