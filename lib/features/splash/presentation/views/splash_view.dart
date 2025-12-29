import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/animations/animate_do.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_state.dart';
import 'package:sana/features/splash/presentation/widgets/splash_logo_and_name.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationCubit>().checkLocationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationSuccess ||
            state is LocationPermissionPermanentlyDenied ||
            state is LocationNeedsPermission) {
          // Once location status is determined (even if denied), we can proceed
          // The LocationGuard on Home will handle the actual enforcement if needed
          context.goNamed(AppRoutes.home);
        }
      },
      child: Scaffold(
        body: Center(
          child: AppAnimations.fadeIn(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300),
            const SplashLogoAndName(),
          ),
        ),
      ),
    );
  }
}
