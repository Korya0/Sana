import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/use_cases/calculate_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_compass_sensor_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_location_permission_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_location_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_app_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_location_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/request_location_permission_use_case.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> with WidgetsBindingObserver {
  QiblaCubit({
    required CheckCompassSensorUseCase checkCompassSensor,
    required CheckLocationPermissionUseCase checkLocationPermission,
    required RequestLocationPermissionUseCase requestLocationPermission,
    required CalculateQiblaDirectionUseCase calculateQiblaDirection,
    required GetCompassStreamUseCase getCompassStream,
    required GetLocationStreamUseCase getLocationStream,
    required OpenAppSettingsUseCase openAppSettings,
    required OpenLocationSettingsUseCase openLocationSettings,
  }) : _checkCompassSensor = checkCompassSensor,
       _checkLocationPermission = checkLocationPermission,
       _requestLocationPermission = requestLocationPermission,
       _calculateQiblaDirection = calculateQiblaDirection,
       _getCompassStream = getCompassStream,
       _getLocationStream = getLocationStream,
       _openAppSettings = openAppSettings,
       _openLocationSettings = openLocationSettings,
       super(const QiblaInitial()) {
    WidgetsBinding.instance.addObserver(this);
  }

  final CheckCompassSensorUseCase _checkCompassSensor;
  final CheckLocationPermissionUseCase _checkLocationPermission;
  final RequestLocationPermissionUseCase _requestLocationPermission;
  final CalculateQiblaDirectionUseCase _calculateQiblaDirection;
  final GetCompassStreamUseCase _getCompassStream;
  final GetLocationStreamUseCase _getLocationStream;
  final OpenAppSettingsUseCase _openAppSettings;
  final OpenLocationSettingsUseCase _openLocationSettings;

  StreamSubscription<CompassSensorData>? _compassSubscription;
  StreamSubscription<dynamic>? _locationSubscription;

  // Initialize
  Future<void> initialize() async {
    if (isClosed) return;

    final sensorResult = await _checkCompassSensor();
    if (isClosed) return;

    switch (sensorResult) {
      case Success(data: final hasSensor):
        if (!hasSensor) {
          emit(const QiblaUnsupported(AppStrings.qiblaUnsupportedMessage));
          return;
        }
      case FailureResult(:final failure):
        emit(QiblaUnsupported(failure.message));
        return;
    }

    final permissionResult = await _checkLocationPermission();
    if (isClosed) return;

    switch (permissionResult) {
      case Success(data: final isGranted):
        if (isGranted) {
          await startTracking();
        } else {
          emit(const QiblaPermission());
        }
      case FailureResult():
        emit(const QiblaPermission());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(recheckOnResume());
    }
  }

  // Recheck
  Future<void> recheckOnResume() async {
    if (isClosed) return;
    if (state is QiblaInitial ||
        state is QiblaPermission ||
        state is QiblaLoading ||
        state is QiblaUnsupported) {
      return;
    }

    final result = await _checkLocationPermission();
    if (isClosed) return;

    final isGranted = switch (result) {
      Success(data: final granted) => granted,
      FailureResult() => false,
    };

    if (isGranted) {
      await startTracking();
      return;
    }

    if (state is! QiblaDenied) {
      emit(const QiblaDenied(AppStrings.qiblaDeniedTitle));
    }
  }

  // Request permission
  Future<void> requestPermission() async {
    if (isClosed) return;

    emit(const QiblaLoading());

    final result = await _requestLocationPermission();
    if (isClosed) return;

    switch (result) {
      case Success(data: final granted):
        if (granted) {
          await startTracking();
        } else {
          emit(const QiblaDenied(AppStrings.qiblaDeniedTitle));
        }
      case FailureResult(:final failure):
        emit(QiblaDenied(failure.message));
    }
  }

  // Start tracking
  Future<void> startTracking() async {
    if (isClosed) return;

    emit(const QiblaLoading());

    await _cancelSubscriptions();
    if (isClosed) return;

    final result = await _calculateQiblaDirection();
    if (isClosed) return;

    switch (result) {
      case Success(data: final qibla):
        emit(
          QiblaCompass(
            qiblaEntity: qibla,
            heading: qibla.phoneHeading,
            tilt: qibla.tilt,
            isLowAccuracy: qibla.isLowAccuracy,
          ),
        );

        _listenToSensors();
        _listenToLocationUpdates();

      case FailureResult(:final failure):
        emit(QiblaFailed(failure.message));
    }
  }

  void _listenToSensors() {
    _compassSubscription = _getCompassStream().listen(
      (sensorData) {
        if (isClosed) return;
        final currentState = state;
        if (currentState is! QiblaCompass) return;

        final current = currentState.qiblaEntity;
        final updated = current.copyWith(
          phoneHeading: sensorData.heading,
          tilt: sensorData.tilt,
          isLowAccuracy: sensorData.isLowAccuracy,
        );

        emit(
          QiblaCompass(
            qiblaEntity: updated,
            heading: sensorData.heading,
            tilt: sensorData.tilt,
            isLowAccuracy: sensorData.isLowAccuracy,
          ),
        );
      },
      onError: (_) {
        // Non-fatal errors
      },
    );
  }

  void _listenToLocationUpdates() {
    _locationSubscription = _getLocationStream().listen(
      (_) async {
        if (isClosed) return;
        final result = await _calculateQiblaDirection();
        if (isClosed) return;

        final currentState = state;
        if (currentState is! QiblaCompass) return;
        if (result case Success(data: final newQibla)) {
          final current = currentState.qiblaEntity;
          final merged = newQibla.copyWith(
            phoneHeading: current.phoneHeading,
            tilt: current.tilt,
            isLowAccuracy: current.isLowAccuracy,
          );
          emit(
            QiblaCompass(
              qiblaEntity: merged,
              heading: current.phoneHeading,
              tilt: current.tilt,
              isLowAccuracy: current.isLowAccuracy,
            ),
          );
        }
      },
      onError: (_) {},
    );
  }

  Future<void> openAppSettings() async {
    if (isClosed) return;
    await _openAppSettings();
  }

  Future<void> openLocationSettings() async {
    if (isClosed) return;
    await _openLocationSettings();
  }

  Future<void> _cancelSubscriptions() async {
    await _compassSubscription?.cancel();
    _compassSubscription = null;
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    await _cancelSubscriptions();
    return super.close();
  }
}
