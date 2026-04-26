import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/location_manager/data/constants/arab_countries.dart';
import 'package:sana/core/services/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

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
          if (widget.forceGPS) {
            unawaited(cubit.enforceLocation());
          } else {
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
      // فقط نقوم بالتحديث إذا لم يكن لدينا موقع مخزن مسبقاً
      // أو إذا كان المستخدم قد أعطى الإذن بالفعل لتحديث الموقع في الخلفية
      final cubit = context.read<LocationCubit>();
      if (widget.forceGPS) {
        unawaited(cubit.enforceLocation());
      } else if (!cubit.hasStoredLocation()) {
        unawaited(cubit.enforceLocation());
      }
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

    // If the sheet is closed and we are NOT in success state AND NOT awaiting resolution, close the screen
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

    final cubit = context.read<LocationCubit>();
    final selectedCountryName = cubit.getStoredLocationName();

    await showCustomBottomSheet(
      context,
      title: 'اختر الدولة',
      child: Column(
        children: [
          const CustomAppDivider(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: arabCountries.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final country = arabCountries[index];
              final isSelected = country.name == selectedCountryName;
              return ListTile(
                title: Text(
                  country.name,
                  style: AppTextStyles.font16W600White(context).copyWith(
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.iconPrimary)
                    : null,
                onTap: () async {
                  Navigator.of(context).pop();
                  await context.read<LocationCubit>().saveManualLocation(
                    lat: country.lat,
                    lng: country.lng,
                    name: country.name,
                  );
                },
              );
            },
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
              (state is LocationError &&
                  state.message == 'SHOW_CHOICE_SHEET' &&
                  _lastShownStateTag == 'choice') ||
              (state is LocationError &&
                  state.message != 'SHOW_CHOICE_SHEET' &&
                  _lastShownStateTag == 'error');

          if (state is LocationSuccess) {
            Navigator.of(context).pop();
          } else if (!isSameState &&
              (state is LocationNeedsServiceEnable ||
                  state is LocationNeedsPermission ||
                  state is LocationPermissionPermanentlyDenied ||
                  (state is LocationError &&
                      state.message == 'SHOW_CHOICE_SHEET') ||
                  (state is LocationError &&
                      state.message != 'SHOW_CHOICE_SHEET'))) {
            _isSwitchingState = true;
            Navigator.of(context).pop();
            while (_isBottomSheetShown) {
              await Future<void>.delayed(const Duration(milliseconds: 50));
            }
            if (!context.mounted) return;
          } else if (isSameState) {
            return; // Nothing to do, already showing correct sheet
          }
        }

        if (state is LocationError && state.message == 'SHOW_CHOICE_SHEET') {
          unawaited(
            _showGuardBottomSheet(
              stateTag: 'choice',
              title: 'تحديد الموقع',
              message: 'يرجى اختيار طريقة لتحديد الموقع والمواقيت',
              primaryButtonText: AppStrings.allow,
              onPrimaryAction: () async {
                await context.read<LocationCubit>().enforceLocation();
              },
              secondaryButtonText: 'اختر دولة',
              onSecondaryAction: () async => _showCountryPicker(context),
            ),
          );
        } else if (state is LocationSuccess) {
          // Already handled closing above if needed
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
                  ? 'اختر دولة'
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
                  ? 'اختر دولة'
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
                await GetIt.I<IAppPermissionsManager>().openSettings();
              },
              secondaryButtonText: widget.showCountryOption
                  ? 'اختر دولة'
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
                  ? 'اختر دولة'
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
                const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          }
        },
      ),
    );
  }
}
