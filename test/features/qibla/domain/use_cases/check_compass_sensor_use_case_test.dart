import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/check_compass_sensor_use_case.dart';

void main() {
  test('returns true when device has compass sensor', () async {
    final repository = _FakeRepository(hasSensor: true);

    final result = await CheckCompassSensorUseCase(repository)();

    final success = result as Success<bool>;
    expect(success.data, true);
  });

  test('returns false when device has no compass sensor', () async {
    final repository = _FakeRepository(hasSensor: false);

    final result = await CheckCompassSensorUseCase(repository)();

    final success = result as Success<bool>;
    expect(success.data, false);
  });

  test('passes failure result through unchanged', () async {
    final repository = _FakeRepository(hasSensor: true, failing: true);

    final result = await CheckCompassSensorUseCase(repository)();

    final failure = result as FailureResult<bool>;
    expect(failure.failure, isA<SensorFailure>());
    expect(failure.failure.message, 'sensor check failed');
    expect(repository.callCount, 1);
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({required this.hasSensor, this.failing = false});

  final bool hasSensor;
  final bool failing;
  int callCount = 0;

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async {
    return const Result.failure(
      CacheFailure(message: 'not implemented in test fake'),
    );
  }

  @override
  Future<Result<bool>> hasCompassSensor() async {
    callCount++;
    if (failing) {
      return const Result.failure(
        SensorFailure(message: 'sensor check failed'),
      );
    }
    return Result.success(hasSensor);
  }

  @override
  Future<Result<bool>> requestLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async =>
      const Result.success(null);

  @override
  Future<Result<bool>> checkLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<LocationModel>> getCurrentLocation() async =>
      const Result.success(LocationModel(latitude: 0, longitude: 0));

  @override
  Stream<CompassSensorData> getCompassStream() => const Stream.empty();

  @override
  Stream<LocationModel> getLocationStream() => const Stream.empty();
}
