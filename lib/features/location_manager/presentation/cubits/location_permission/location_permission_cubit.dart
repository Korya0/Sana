import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/location_manager/data/repos/location_repository.dart';
import 'package:sana/features/location_manager/presentation/cubits/location_permission/location_state.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';

/// Manages location permission flow: checking, requesting, and handling
/// permission states (denied, permanently denied, service disabled).
class LocationPermissionCubit extends Cubit<LocationState> {
  LocationPermissionCubit({
    required LocationRepository repository,
    required AppPermissionsManager permissionsManager,
    required this.onPositionGranted,
  })  : _repository = repository,
        _permissionsManager = permissionsManager,
        super(const LocationInitial()) {
    _init();
  }

  final LocationRepository _repository;
  final AppPermissionsManager _permissionsManager;

  /// Callback invoked when permission is granted and position should be saved.
  final Future<void> Function() onPositionGranted;

  int _deniedCount = 0;
  bool _isEnforcing = false;

  Future<void> openAppSettings() async {
    await _permissionsManager.openSettings();
  }

  void _init() {
    try {
      if (_repository.hasStoredLocation()) {
        emit(
          const LocationSuccess(
            message: AppStrings.locationStoredCheckSuccess,
          ),
        );
      }
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError('LocationPermissionCubit Init Error',
            error: e, stackTrace: stack),
      );
    }
  }

  Future<void> checkLocationStatus() async {
    if (_repository.hasStoredLocation()) {
      emit(const LocationSuccess(message: AppStrings.locationStoredCheckSuccess));
    } else {
      await enforceLocation();
    }
  }

  void requestChoice() {
    if (!isClosed) {
      emit(const LocationShowChoiceSheet());
    }
  }

  void skipLocation() {
    if (!isClosed) {
      emit(const LocationSkipped());
    }
  }

  Future<void> enforceLocation() async {
    if (_isEnforcing) return;
    _isEnforcing = true;
    if (!isClosed) emit(const LocationLoading());

    // Check if location service is enabled
    final isEnabledResult = await _repository.isLocationEnabled();
    final isEnabled = switch (isEnabledResult) {
      Success(:final data) => data,
      FailureResult() => false,
    };

    if (!isEnabled) {
      if (!isClosed) emit(const LocationNeedsServiceEnable());
      _isEnforcing = false;
      return;
    }

    // Check permission
    final hasPermissionResult = await _repository.hasPermission();
    final hasPermission = switch (hasPermissionResult) {
      Success(:final data) => data,
      FailureResult() => false,
    };

    if (!hasPermission) {
      final statusResult = await _repository.getPermissionStatus();
      final status = switch (statusResult) {
        Success(:final data) => data,
        FailureResult() => AppLocationPermission.denied,
      };

      if (status == AppLocationPermission.deniedForever) {
        if (!isClosed) emit(const LocationPermissionPermanentlyDenied());
      } else {
        if (!isClosed) emit(const LocationNeedsPermission());
      }
      _isEnforcing = false;
      return;
    }

    // Permission granted — save position via callback
    await onPositionGranted();
    _isEnforcing = false;
  }

  Future<void> enableLocationService() async {
    final result = await _repository.openLocationSettings();
    switch (result) {
      case Success():
        break;
      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
  }

  Future<void> requestLocationPermission() async {
    final result = await _repository.requestPermission();

    switch (result) {
      case Success(:final data):
        final perm = data;
        if (perm == AppLocationPermission.deniedForever) {
          if (!isClosed) emit(const LocationPermissionPermanentlyDenied());
          return;
        }

        if (perm == AppLocationPermission.denied) {
          _deniedCount++;
          if (_deniedCount >= 2) {
            if (!isClosed) emit(const LocationPermissionPermanentlyDenied());
          } else {
            if (!isClosed) emit(const LocationNeedsPermission());
          }
          return;
        }

        // Permission granted (whileInUse or always)
        _deniedCount = 0;
        await onPositionGranted();

      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
  }

  /// Resets the enforcing flag and emits success.
  void onPositionSaved() {
    if (!isClosed) {
      emit(const LocationSuccess(message: AppStrings.locationSavedSuccess));
    }
  }

  Future<void> retryFirstTime() async {
    await checkLocationStatus();
  }
}
