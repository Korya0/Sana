import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/location_manager/presentation/widgets/location_guard.dart';
import 'package:sana/features/splash/presentation/widgets/splash_logo_and_name.dart';

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
        loadingPlaceholder: Center(
          child: AppAnimations.fadeIn(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300),
            const SplashLogoAndName(),
          ),
        ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.goNamed(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppAnimations.fadeIn(
        delay: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 300),
        const SplashLogoAndName(),
      ),
    );
  }
}
