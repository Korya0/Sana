import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/calculate_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_compass_sensor_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_location_permission_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_location_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_app_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_location_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/request_location_permission_use_case.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';

// Scenario controls for the integration test.
class QiblaScenario {
  QiblaScenario({
    this.hasSensor = true,
    this.permissionGranted = true,
    this.requestGrants = true,
    this.sensorFailure = false,
    this.permissionFailure = false,
    this.locationFailure = false,
    this.calculateFailure = false,
    this.initialLocation,
    this.initialEntity,
  });

  bool hasSensor;
  bool permissionGranted;
  bool requestGrants;
  bool sensorFailure;
  bool permissionFailure;
  bool locationFailure;
  bool calculateFailure;
  LocationModel? initialLocation;
  QiblaEntity? initialEntity;

  static LocationModel cairo() => const LocationModel(
    latitude: 30.0444,
    longitude: 31.2357,
    heading: 0.0,
  );

  static QiblaEntity entity({double direction = 135.0, double? heading}) =>
      QiblaEntity(
        direction: direction,
        distanceKm: 1200.0,
        location: const QiblaLocation(latitude: 30.0444, longitude: 31.2357),
        phoneHeading: heading,
      );
}

// Controllable repository used by the real cubit and use cases.
class FakeQiblaRepository implements QiblaRepository {
  FakeQiblaRepository(this.scenario);

  final QiblaScenario scenario;
  final StreamController<CompassSensorData> _compass =
      StreamController<CompassSensorData>.broadcast();
  final StreamController<LocationModel> _location =
      StreamController<LocationModel>.broadcast();

  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;
  int requestPermissionCalls = 0;
  int calculateCalls = 0;

  @override
  Future<Result<bool>> hasCompassSensor() async => scenario.sensorFailure
      ? const Result.failure(SensorFailure(message: 'sensor error'))
      : Result.success(scenario.hasSensor);

  @override
  Future<Result<bool>> checkLocationPermission() async =>
      scenario.permissionFailure
          ? const Result.failure(PermissionFailure(message: 'permission error'))
          : Result.success(scenario.permissionGranted);

  @override
  Future<Result<bool>> requestLocationPermission() async {
    requestPermissionCalls++;
    scenario.permissionGranted = scenario.requestGrants;
    return Result.success(scenario.requestGrants);
  }

  @override
  Future<Result<LocationModel>> getCurrentLocation() async =>
      scenario.locationFailure
          ? const Result.failure(LocationFailure(message: 'location error'))
          : Result.success(scenario.initialLocation ?? QiblaScenario.cairo());

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async {
    calculateCalls++;
    if (scenario.calculateFailure) {
      return const Result.failure(LocationFailure(message: 'calculate error'));
    }
    return Result.success(scenario.initialEntity ?? QiblaScenario.entity());
  }

  @override
  Stream<CompassSensorData> getCompassStream() => _compass.stream;

  @override
  Stream<LocationModel> getLocationStream() => _location.stream;

  @override
  Future<Result<void>> openAppSettings() async {
    openAppSettingsCalls++;
    return const Result.success(null);
  }

  @override
  Future<Result<void>> openLocationSettings() async {
    openLocationSettingsCalls++;
    return const Result.success(null);
  }

  void emitCompass(CompassSensorData data) => _compass.add(data);
  void emitLocation(LocationModel data) => _location.add(data);

  Future<void> dispose() async {
    await _compass.close();
    await _location.close();
  }
}

// Registers the real use cases and cubit with the fake repository.
FakeQiblaRepository registerQibla(QiblaScenario scenario) {
  final repo = FakeQiblaRepository(scenario);
  sl.allowReassignment = true;
  sl
    ..registerLazySingleton<QiblaRepository>(() => repo)
    ..registerLazySingleton(() => CalculateQiblaDirectionUseCase(sl()))
    ..registerLazySingleton(() => CheckCompassSensorUseCase(sl()))
    ..registerLazySingleton(() => CheckLocationPermissionUseCase(sl()))
    ..registerLazySingleton(() => RequestLocationPermissionUseCase(sl()))
    ..registerLazySingleton(() => GetCompassStreamUseCase(sl()))
    ..registerLazySingleton(() => GetLocationStreamUseCase(sl()))
    ..registerLazySingleton(() => OpenAppSettingsUseCase(sl()))
    ..registerLazySingleton(() => OpenLocationSettingsUseCase(sl()))
    ..registerFactory(
      () => QiblaCubit(
        checkCompassSensor: sl(),
        checkLocationPermission: sl(),
        requestLocationPermission: sl(),
        calculateQiblaDirection: sl(),
        getCompassStream: sl(),
        getLocationStream: sl(),
        openAppSettings: sl(),
        openLocationSettings: sl(),
      ),
    );
  return repo;
}

// Pumps the real QiblaView through a real GoRouter on the device.
Future<FakeQiblaRepository> pumpQiblaFlow(
  WidgetTester tester,
  QiblaScenario scenario, {
  bool navigateFromSettings = false,
}) async {
  final repo = registerQibla(scenario);

  final router = GoRouter(
    initialLocation: navigateFromSettings ? '/settings' : '/qibla',
    routes: [
      GoRoute(
        path: '/settings',
        builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
      ),
      GoRoute(
        path: '/qibla',
        builder: (context, state) => const QiblaView(),
      ),
    ],
  );

  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    ),
  );
  await tester.pump();

  if (navigateFromSettings) {
    router.go('/qibla');
    await tester.pump();
  }

  await tester.pump(const Duration(milliseconds: 400));
  return repo;
}
