import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/location_result.dart';
import 'package:sana/core/services/location/location_service.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source_impl.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository_impl.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
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

class _CountingLocationService implements LocationService {
  int calls = 0;

  @override
  Future<Result<bool>> checkPermission() async => const Success(true);

  @override
  Future<Result<bool>> requestPermission() async => const Success(true);

  @override
  Future<Result<LocationResult>> getCurrentLocation() async {
    calls++;
    return Success(
      LocationResult(
        latitude: 30.0444,
        longitude: 31.2357,
        heading: 0,
        takenAt: DateTime.now(),
      ),
    );
  }

  @override
  Stream<LocationResult> watchLocation() => const Stream.empty();

  @override
  Future<Result<void>> openAppSettings() async => const Success(null);

  @override
  Future<Result<void>> openLocationSettings() async => const Success(null);
}

class _StubCompassDataSource implements CompassLocalDataSource {
  @override
  Future<bool> hasCompassSensor() async => true;

  @override
  Stream<CompassSensorData> onCompassChanged() => const Stream.empty();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('entering Qibla twice requests a fresh location each time', (
    tester,
  ) async {
    final locationService = _CountingLocationService();
    final repository = QiblaRepositoryImpl(
      LocationLocalDataSourceImpl(locationService),
      _StubCompassDataSource(),
      const AppLogger(),
      locationService,
    );

    sl.allowReassignment = true;
    sl
      ..registerLazySingleton<QiblaRepository>(() => repository)
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

    final router = GoRouter(
      initialLocation: '/settings',
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

    router.go('/qibla');
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.byType(QiblaView), findsOneWidget);
    expect(locationService.calls, 1);

    router.go('/settings');
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    router.go('/qibla');
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(locationService.calls, 2);
  });
}
