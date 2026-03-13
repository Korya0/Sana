import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';

class LocationGuard extends StatefulWidget {
  const LocationGuard({
    required this.child,
    super.key,
    this.enforceOnInit = true,
    this.loadingPlaceholder,
    this.showCancelButton = true,
    this.onClose,
    this.onInit,
  });
  final Widget child;
  final bool enforceOnInit;
  final Widget? loadingPlaceholder;

  final bool showCancelButton;
  final VoidCallback? onClose;
  final void Function(BuildContext context)? onInit;

  @override
  State<LocationGuard> createState() => _LocationGuardState();
}

class _LocationGuardState extends State<LocationGuard>
    with WidgetsBindingObserver {
  bool _isBottomSheetShown = false;
  bool _isAwaitingResolution = false;
  bool _isSwitchingState = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.enforceOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (widget.onInit != null) {
          widget.onInit!(context);
        } else {
          unawaited(context.read<LocationCubit>().enforceLocation());
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(context.read<LocationCubit>().enforceLocation());
    }
  }

  void _closeScreen() {
    if (widget.onClose != null) {
      widget.onClose!();
      return;
    }
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showGuardBottomSheet({
    required String title,
    required String message,
    required String primaryButtonText,
    required VoidCallback onPrimaryAction,
    String? secondaryButtonText,
    VoidCallback? onSecondaryAction,
  }) async {
    if (_isBottomSheetShown) return;

    _isBottomSheetShown = true;
    _isAwaitingResolution = false;
    _isSwitchingState = false;

    await showCustomBottomSheet(
      context,
      isDismissible: widget.showCancelButton,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      onPrimaryAction: () {
        _isAwaitingResolution = true;
        onPrimaryAction();
      },
      secondaryButtonText: widget.showCancelButton
          ? (secondaryButtonText ?? AppStrings.cancel)
          : null,
      onSecondaryAction: widget.showCancelButton
          ? (onSecondaryAction ?? _closeScreen)
          : null,
    );
    _isBottomSheetShown = false;

    if (_isSwitchingState) {
      _isSwitchingState = false;
      return;
    }

    // If the sheet is closed and we are NOT in success state AND NOT awaiting resolution, close the screen
    if (mounted) {
      final state = context.read<LocationCubit>().state;
      if (state is! LocationSuccess && !_isAwaitingResolution) {
        _closeScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) async {
          if (_isBottomSheetShown) {
            if (state is LocationSuccess) {
              Navigator.of(context).pop(); // Close the bottom sheet
            } else if (state is LocationNeedsServiceEnable ||
                state is LocationNeedsPermission ||
                state is LocationPermissionPermanentlyDenied ||
                state is LocationError) {
              _isSwitchingState = true;
              Navigator.of(context).pop();
              while (_isBottomSheetShown) {
                await Future<void>.delayed(const Duration(milliseconds: 50));
              }
              if (!context.mounted) return;
            }
          }

          if (state is LocationSuccess) {
            // Already handled closing above if needed
          } else if (state is LocationNeedsServiceEnable) {
            unawaited(
              _showGuardBottomSheet(
                title: AppStrings.enableLocationServiceTitle,
                message: AppStrings.enableLocationServiceMessage,
                primaryButtonText: AppStrings.enable,
                onPrimaryAction: () async {
                  await context.read<LocationCubit>().enableLocationService();
                },
              ),
            );
          } else if (state is LocationNeedsPermission) {
            unawaited(
              _showGuardBottomSheet(
                title: AppStrings.locationPermissionTitle,
                message: AppStrings.locationPermissionMessage,
                primaryButtonText: AppStrings.allow,
                onPrimaryAction: () async {
                  await context
                      .read<LocationCubit>()
                      .requestLocationPermission();
                },
              ),
            );
          } else if (state is LocationPermissionPermanentlyDenied) {
            unawaited(
              _showGuardBottomSheet(
                title: AppStrings.locationPermissionPermanentlyDeniedTitle,
                message: AppStrings.locationPermissionPermanentlyDeniedMessage,
                primaryButtonText: AppStrings.openAppSettings,
                onPrimaryAction: () async {
                  await Geolocator.openAppSettings();
                },
              ),
            );
          } else if (state is LocationError) {
            unawaited(
              _showGuardBottomSheet(
                title: AppStrings.errorWidgetTitle,
                message: state.message,
                primaryButtonText: AppStrings.tryAgain,
                onPrimaryAction: () async {
                  await context.read<LocationCubit>().retryFirstTime();
                },
              ),
            );
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationSuccess) {
              return FutureBuilder(
                future: Future<void>.delayed(const Duration(milliseconds: 100)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return widget.child;
                  } else {
                    return widget.loadingPlaceholder ?? const Scaffold();
                  }
                },
              );
            } else {
              return widget.loadingPlaceholder ?? const Scaffold();
            }
          },
        ),
      ),
    );
  }
}
