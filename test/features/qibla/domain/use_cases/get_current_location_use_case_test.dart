import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/get_current_location_use_case.dart';

void main() {
  test('delegates and returns current location', () async {
    final repository = _FakeRepository();

    final result = await GetCurrentLocationUseCase(repository)();

    final success = result as Success<LocationModel>;
    expect(success.data.latitude, 30.0444);
    expect(success.data.longitude, 31.2357);
    expect(repository.callCount, 1);
  });

  test('passes failure result through', () async {
    final repository = _FakeRepository(failing: true);

    final result = await GetCurrentLocationUseCase(repository)();

    final failure = result as FailureResult<LocationModel>;
    expect(failure.failure, isA<LocationFailure>());
    expect(repository.callCount, 1);
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({this.failing = false});

  final bool failing;
  int callCount = 0;

  @override
  Future<Result<LocationModel>> getCurrentLocation() async {
    callCount++;
    if (failing) {
      return const Result.failure(LocationFailure(message: 'test failure'));
    }
    return const Result.success(
      LocationModel(latitude: 30.0444, longitude: 31.2357),
    );
  }

  @override
  Future<Result<bool>> hasCompassSensor() async => const Result.success(true);

  @override
  Future<Result<bool>> checkLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<bool>> requestLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async =>
      const Result.success(
        QiblaEntity(
          direction: 0,
          distanceKm: 0,
          location: QiblaLocation(latitude: 0, longitude: 0),
        ),
      );

  @override
  Stream<CompassSensorData> getCompassStream() => const Stream.empty();

  @override
  Stream<LocationModel> getLocationStream() => const Stream.empty();

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async =>
      const Result.success(null);
}
