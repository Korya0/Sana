import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/di/features/qibla_di.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/calculate_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_compass_sensor_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_location_permission_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_current_location_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_location_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_app_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_location_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/request_location_permission_use_case.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_cubit.dart';

void main() {
  late GetIt container;

  setUp(() {
    container = GetIt.asNewInstance();
    container.registerLazySingleton<AppLogger>(() => const AppLogger());
  });

  tearDown(() async {
    await container.reset();
  });

  test('registers data sources and repository', () {
    setupQiblaDependencies(container);

    expect(container.isRegistered<LocationLocalDataSource>(), isTrue);
    expect(container.isRegistered<CompassLocalDataSource>(), isTrue);
    expect(container.isRegistered<QiblaRepository>(), isTrue);
  });

  test('registers every use case', () {
    setupQiblaDependencies(container);

    expect(container.isRegistered<CalculateQiblaDirectionUseCase>(), isTrue);
    expect(container.isRegistered<CheckCompassSensorUseCase>(), isTrue);
    expect(container.isRegistered<CheckLocationPermissionUseCase>(), isTrue);
    expect(container.isRegistered<RequestLocationPermissionUseCase>(), isTrue);
    expect(container.isRegistered<GetCompassStreamUseCase>(), isTrue);
    expect(container.isRegistered<GetLocationStreamUseCase>(), isTrue);
    expect(container.isRegistered<GetCurrentLocationUseCase>(), isTrue);
    expect(container.isRegistered<OpenAppSettingsUseCase>(), isTrue);
    expect(container.isRegistered<OpenLocationSettingsUseCase>(), isTrue);
  });

  test('registers the cubit as a factory', () {
    setupQiblaDependencies(container);

    expect(container.isRegistered<QiblaCubit>(), isTrue);
  });
}
