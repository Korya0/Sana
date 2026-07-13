import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/location_manager/data/repos/i_location_repository.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_permission_cubit.dart'
    show LocationPermissionCubit;
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_state.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_position/location_position_cubit.dart'
    show LocationPositionCubit;

/// Facade that coordinates [LocationPermissionCubit] and [LocationPositionCubit]
/// for backward compatibility. New code should prefer the individual cubits.
class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    required ILocationRepository repository,
    required IAppPermissionsManager permissionsManager,
  }) : _repository = repository,
       _permissionsManager = permissionsManager,
       super(const LocationInitial()) {
    _init();
  }

  final ILocationRepository _repository;
  final IAppPermissionsManager _permissionsManager;

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
        AppLogger.localError(
          'LocationCubit Init Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  Future<void> checkLocationStatus() async {
    if (_repository.hasStoredLocation()) {
      if (!isClosed) {
        emit(
          const LocationSuccess(
            message: AppStrings.locationStoredCheckSuccess,
          ),
        );
      }
    } else {
      await enforceLocation();
    }
  }

  bool hasStoredLocation() => _repository.hasStoredLocation();
  String? getStoredLocationName() => _repository.getStoredLocationName();

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

    await _savePosition();
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

        _deniedCount = 0;
        await _savePosition();

      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
  }

  Future<void> _savePosition() async {
    if (!isClosed) emit(const LocationLoading());
    final result = await _repository.saveCurrentPosition();
    switch (result) {
      case Success():
        emit(const LocationSuccess(message: AppStrings.locationSavedSuccess));
      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
    _isEnforcing = false;
  }

  Future<void> saveManualLocation({
    required double lat,
    required double lng,
    required String name,
  }) async {
    if (!isClosed) emit(const LocationLoading());
    final result = await _repository.saveManualPosition(
      lat: lat,
      lng: lng,
      name: name,
    );
    switch (result) {
      case Success():
        emit(const LocationSuccess(message: AppStrings.locationSavedSuccess));
      case FailureResult(:final failure):
        emit(LocationError(message: failure.message));
    }
    _isEnforcing = false;
  }

  Future<void> retryFirstTime() async {
    await checkLocationStatus();
  }
}
