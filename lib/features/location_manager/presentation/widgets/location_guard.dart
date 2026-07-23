import 'package:sana/core/routing/app_navigator.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/location_manager/data/constants/arab_countries.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_state.dart';
import 'package:sana/features/location_manager/presentation/widgets/location_country_picker.dart';
import 'package:sana/features/location_manager/presentation/widgets/location_loading_skeleton.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/common/overlays/bottom_sheet/app_bottom_sheet.dart';

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
  bool _needsForceGPS = false;
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
          if (widget.forceGPS) {
            setState(() {
              _needsForceGPS = true;
            });
            unawaited(cubit.enforceLocation());
          } else if (cubit.state is LocationInitial) {
            unawaited(cubit.checkLocationStatus());
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
        Future<void>.delayed(AppConstants.animationSlower500ms).then((_) {
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
    if (mounted && AppNavigator.canPop(context)) {
      AppNavigator.pop(context);
    }
  }

  Future<void> _showGuardBottomSheet({
    required String title,
    required String message,
    required VoidCallback onPrimaryAction,
    VoidCallback? onSecondaryAction,
    String? stateTag,
  }) async {
    if (_isBottomSheetShown) return;

    _isBottomSheetShown = true;
    _lastShownStateTag = stateTag;
    _isAwaitingResolution = false;
    _isSwitchingState = false;

    await AppBottomSheet.show<void>(
      context: context,
      isDismissible: widget.showCancelButton,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.font20W700(context)
                .copyWith(color: context.color.textPrimary),
            textAlign: TextAlign.center,
          ),
          const AppGap.h(AppSpacing.v8),
          Text(
            message,
            style: AppTextStyles.font14W500(context)
                .copyWith(color: context.color.textSecondary),
            textAlign: TextAlign.center,
          ),
          const AppGap.h(AppSpacing.v24),
          AppSecondaryButton(
            text: AppStrings.activateLocation,
            onPressed: () {
              AppNavigator.pop(context);
              _isAwaitingResolution = true;
              onPrimaryAction();
            },
          ),
          if (widget.showCountryOption) ...[
            const AppGap.h(AppSpacing.v12),
            AppSecondaryButton(
              text: AppStrings.chooseCountry,
              onPressed: () {
                AppNavigator.pop(context);
                if (onSecondaryAction != null) {
                  onSecondaryAction();
                } else {
                  unawaited(_showCountryPicker(context));
                }
              },
            ),
          ],
          if (!widget.forceGPS) ...[
            const AppGap.h(AppSpacing.v12),
            AppSecondaryButton(
              text: AppStrings.enterWithoutLocation,
              borderColor: context.color.error,
              textColor: context.color.error,
              onPressed: () {
                AppNavigator.pop(context);
                context.read<LocationCubit>().skipLocation();
              },
            ),
          ],
        ],
      ),
    );
    _isBottomSheetShown = false;

    if (_isSwitchingState) {
      _isSwitchingState = false;
      return;
    }

    if (mounted) {
      final state = context.read<LocationCubit>().state;
      if (state is! LocationSuccess &&
          state is! LocationSkipped &&
          !_isAwaitingResolution) {
        _closeScreen();
      }
    }
  }

  Future<void> _showCountryPicker(BuildContext context) async {
    _isSwitchingState = true;
    _isBottomSheetShown = true;
    _lastShownStateTag = 'country';

    final cubit = context.read<LocationCubit>();
    await AppBottomSheet.show<void>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.selectCountry,
            style: AppTextStyles.font20W700(context)
                .copyWith(color: context.color.textPrimary),
            textAlign: TextAlign.center,
          ),
          const AppGap.h(AppSpacing.v24),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.7,
              ),
              child: LocationCountryPicker(
                countries: arabCountries,
                selectedCountryName: cubit.getStoredLocationName(),
                onCountrySelected: (country) async {
                  AppNavigator.pop(context);
                  await cubit.saveManualLocation(
                    lat: country.lat,
                    lng: country.lng,
                    name: country.name,
                  );
                },
              ),
            ),
          ),
        ],
      ),
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

          if (state is LocationSuccess || state is LocationSkipped) {
            if (context.mounted && AppNavigator.canPop(context)) {
              AppNavigator.pop(context);
            }
          } else if (!isSameState &&
              (state is LocationNeedsServiceEnable ||
                  state is LocationNeedsPermission ||
                  state is LocationPermissionPermanentlyDenied ||
                  state is LocationShowChoiceSheet ||
                  state is LocationError)) {
            _isSwitchingState = true;
            if (context.mounted && AppNavigator.canPop(context)) {
              AppNavigator.pop(context);
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
              onPrimaryAction: () async {
                await context.read<LocationCubit>().enforceLocation();
              },
              onSecondaryAction: () async => _showCountryPicker(context),
            ),
          );
        } else if (state is LocationSuccess || state is LocationSkipped) {
          if (_needsForceGPS) {
            setState(() {
              _needsForceGPS = false;
            });
          }
        } else if (state is LocationNeedsServiceEnable) {
          unawaited(
            _showGuardBottomSheet(
              stateTag: 'service',
              title: AppStrings.enableLocationServiceTitle,
              message: AppStrings.enableLocationServiceMessage,
              onPrimaryAction: () async {
                await context.read<LocationCubit>().enableLocationService();
              },
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
              onPrimaryAction: () async {
                await context.read<LocationCubit>().requestLocationPermission();
              },
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
              onPrimaryAction: () async {
                await context.read<LocationCubit>().openAppSettings();
              },
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
              onPrimaryAction: () async {
                await context.read<LocationCubit>().retryFirstTime();
              },
              onSecondaryAction: widget.showCountryOption
                  ? () async => _showCountryPicker(context)
                  : null,
            ),
          );
        }
      },
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (_needsForceGPS) {
            return widget.loadingPlaceholder ??
                LocationLoadingSkeleton(
                  child: widget.child,
                );
          }
          if (state is LocationSuccess ||
              state is LocationSkipped ||
              !widget.enforceOnInit) {
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
