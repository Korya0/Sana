import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_state.dart';
import 'package:sana/core/services/location_manager/presentation/widgets/location_country_picker.dart';
import 'package:sana/core/services/location_manager/presentation/widgets/location_loading_skeleton.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';

class LocationGuard extends StatefulWidget {
  const LocationGuard({
    required this.child,
    super.key,
    this.enforceOnInit = true,
    this.loadingPlaceholder,
    this.showCancelButton = true,
    this.onClose,
    this.onInit,
    this.showCountryOption = true,
    this.forceGPS = false,
  });
  final Widget child;
  final bool enforceOnInit;
  final Widget? loadingPlaceholder;

  final bool showCancelButton;
  final bool showCountryOption;
  final bool forceGPS;
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
  String? _lastShownStateTag;

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
          final cubit = context.read<LocationCubit>();
          if (cubit.state is LocationInitial) {
            if (widget.forceGPS) {
              unawaited(cubit.enforceLocation());
            } else {
              unawaited(cubit.checkLocationStatus());
            }
          }
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
      // Debounce: Wait a bit to ensure the app has actually stabilized after resume
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 500)).then((_) {
          if (!mounted) return;

          final cubit = context.read<LocationCubit>();
          // Only enforce if we don't have a success state or if GPS is forced
          if (state == AppLifecycleState.resumed) {
            if (widget.forceGPS) {
              unawaited(cubit.enforceLocation());
            } else if (!cubit.hasStoredLocation()) {
              unawaited(cubit.enforceLocation());
            }
          }
        }),
      );
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
    String? stateTag,
  }) async {
    if (_isBottomSheetShown) return;

    _isBottomSheetShown = true;
    _lastShownStateTag = stateTag;
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
      secondaryButtonText:
          secondaryButtonText ??
          (widget.showCancelButton ? AppStrings.cancel : null),
      onSecondaryAction:
          onSecondaryAction ?? (widget.showCancelButton ? _closeScreen : null),
    );
    _isBottomSheetShown = false;

    if (_isSwitchingState) {
      _isSwitchingState = false;
      return;
    }

    if (mounted) {
      final state = context.read<LocationCubit>().state;
      if (state is! LocationSuccess && !_isAwaitingResolution) {
        _closeScreen();
      }
    }
  }

  Future<void> _showCountryPicker(BuildContext context) async {
    _isSwitchingState = true;
    _isBottomSheetShown = true;
    _lastShownStateTag = 'country';

    await showCustomBottomSheet(
      context,
      title: AppStrings.selectCountry,
      child: const LocationCountryPicker(),
    );
    _isBottomSheetShown = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) async {
        if (_isBottomSheetShown) {
          final isSameState =
              (state is LocationNeedsServiceEnable &&
                  _lastShownStateTag == 'service') ||
              (state is LocationNeedsPermission &&
                  _lastShownStateTag == 'permission') ||
              (state is LocationPermissionPermanentlyDenied &&
                  _lastShownStateTag == 'denied') ||
              (state is LocationShowChoiceSheet &&
                  _lastShownStateTag == 'choice') ||
              (state is LocationError && _lastShownStateTag == 'error');

          if (state is LocationSuccess) {
            if (context.mounted && context.canPop()) {
              context.pop();
            }
          } else if (!isSameState &&
              (state is LocationNeedsServiceEnable ||
                  state is LocationNeedsPermission ||
                  state is LocationPermissionPermanentlyDenied ||
                  state is LocationShowChoiceSheet ||
                  state is LocationError)) {
            _isSwitchingState = true;
            if (context.mounted && context.canPop()) {
              context.pop();
            }
            // Allow pop animation to start and state to clear
            await Future<void>.delayed(const Duration(milliseconds: 100));
            if (!context.mounted) return;
          } else if (isSameState) {
            return;
          }
        }

        if (state is LocationShowChoiceSheet) {
          unawaited(
            _showGuardBottomSheet(
              stateTag: 'choice',
              title: AppStrings.determineLocation,
              message: AppStrings.chooseLocationMethodMessage,
              primaryButtonText: AppStrings.allow,
              onPrimaryAction: () async {
                await context.read<LocationCubit>().enforceLocation();
              },
              secondaryButtonText: AppStrings.chooseCountry,
              onSecondaryAction: () async => _showCountryPicker(context),
            ),
          );
        } else if (state is LocationSuccess) {
          // Success
        } else if (state is LocationNeedsServiceEnable) {
          unawaited(
            _showGuardBottomSheet(
              stateTag: 'service',
              title: AppStrings.enableLocationServiceTitle,
              message: AppStrings.enableLocationServiceMessage,
              primaryButtonText: AppStrings.enable,
              onPrimaryAction: () async {
                await context.read<LocationCubit>().enableLocationService();
              },
              secondaryButtonText: widget.showCountryOption
                  ? AppStrings.chooseCountry
                  : null,
              onSecondaryAction: widget.showCountryOption
                  ? () async => _showCountryPicker(context)
                  : null,
            ),
          );
        } else if (state is LocationNeedsPermission) {
          unawaited(
            _showGuardBottomSheet(
              stateTag: 'permission',
              title: AppStrings.locationPermissionTitle,
              message: AppStrings.locationPermissionMessage,
              primaryButtonText: AppStrings.allow,
              onPrimaryAction: () async {
                await context.read<LocationCubit>().requestLocationPermission();
              },
              secondaryButtonText: widget.showCountryOption
                  ? AppStrings.chooseCountry
                  : null,
              onSecondaryAction: widget.showCountryOption
                  ? () async => _showCountryPicker(context)
                  : null,
            ),
          );
        } else if (state is LocationPermissionPermanentlyDenied) {
          unawaited(
            _showGuardBottomSheet(
              stateTag: 'denied',
              title: AppStrings.locationPermissionPermanentlyDeniedTitle,
              message: AppStrings.locationPermissionPermanentlyDeniedMessage,
              primaryButtonText: AppStrings.openAppSettings,
              onPrimaryAction: () async {
                await sl<IAppPermissionsManager>().openSettings();
              },
              secondaryButtonText: widget.showCountryOption
                  ? AppStrings.chooseCountry
                  : null,
              onSecondaryAction: widget.showCountryOption
                  ? () async => _showCountryPicker(context)
                  : null,
            ),
          );
        } else if (state is LocationError) {
          unawaited(
            _showGuardBottomSheet(
              stateTag: 'error',
              title: AppStrings.errorWidgetTitle,
              message: state.message,
              primaryButtonText: AppStrings.tryAgain,
              onPrimaryAction: () async {
                await context.read<LocationCubit>().retryFirstTime();
              },
              secondaryButtonText: widget.showCountryOption
                  ? AppStrings.chooseCountry
                  : null,
              onSecondaryAction: widget.showCountryOption
                  ? () async => _showCountryPicker(context)
                  : null,
            ),
          );
        }
      },
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationSuccess || !widget.enforceOnInit) {
            return widget.child;
          } else {
            return widget.loadingPlaceholder ??
                LocationLoadingSkeleton(
                  child: widget.child,
                );
          }
        },
      ),
    );
  }
}
