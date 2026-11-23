import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

void main() {
  test('exposes complete repository method surface', () async {
    final QiblaRepository repository = _FakeRepository();

    expect((await repository.hasCompassSensor() as Success<bool>).data, isTrue);
    expect(
      (await repository.checkLocationPermission() as Success<bool>).data,
      isTrue,
    );
    expect(
      (await repository.requestLocationPermission() as Success<bool>).data,
      isTrue,
    );
    expect(
      (await repository.getCurrentLocation() as Success<LocationModel>)
          .data
          .latitude,
      20,
    );
    expect(
      (await repository.calculateQiblaDirection() as Success<QiblaEntity>)
          .data
          .direction,
      100,
    );
    expect((await repository.getCompassStream().first).heading, 10);
    expect((await repository.getLocationStream().first).latitude, 20);
    expect(await repository.openAppSettings(), isA<Success<void>>());
    expect(await repository.openLocationSettings(), isA<Success<void>>());
  });

  test('passes failure results through the surface', () async {
    final QiblaRepository repository = _FakeRepository(failing: true);

    final result = await repository.hasCompassSensor();

    final failure = result as FailureResult<bool>;
    expect(failure.failure, isA<SensorFailure>());
    expect(failure.failure.message, 'surface error');
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({this.failing = false});

  final bool failing;

  @override
  Future<Result<bool>> hasCompassSensor() async => failing
      ? const Result.failure(SensorFailure(message: 'surface error'))
      : const Result.success(true);

  @override
  Future<Result<bool>> checkLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<bool>> requestLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<LocationModel>> getCurrentLocation() async =>
      const Result.success(LocationModel(latitude: 20, longitude: 30));

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async =>
      const Result.success(
        QiblaEntity(
          direction: 100,
          distanceKm: 1000,
          location: QiblaLocation(latitude: 20, longitude: 30),
        ),
      );

  @override
  Stream<CompassSensorData> getCompassStream() => Stream.value(
    const CompassSensorData(heading: 10, tilt: 0),
  );

  @override
  Stream<LocationModel> getLocationStream() => Stream.value(
    const LocationModel(latitude: 20, longitude: 30),
  );

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async =>
      const Result.success(null);
}
