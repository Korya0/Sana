import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/get_compass_stream_use_case.dart';

void main() {
  test('delegates and emits compass data', () async {
    final repository = _FakeRepository();

    final data = await GetCompassStreamUseCase(repository)().first;

    expect(data.heading, 33.0);
    expect(data.tilt, 4.0);
    expect(repository.callCount, 1);
  });

  test('forwards stream errors', () async {
    final repository = _FakeRepository(failing: true);

    final errors = GetCompassStreamUseCase(repository)().toList();

    await expectLater(errors, throwsA(isA<StateError>()));
    expect(repository.callCount, 1);
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({this.failing = false});

  final bool failing;
  int callCount = 0;

  @override
  Stream<CompassSensorData> getCompassStream() {
    callCount++;
    if (failing) {
      return Stream.error(StateError('stream failure'));
    }
    return Stream.value(
      const CompassSensorData(heading: 33, tilt: 4),
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
  Future<Result<LocationModel>> getCurrentLocation() async =>
      const Result.success(LocationModel(latitude: 0, longitude: 0));

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
  Stream<LocationModel> getLocationStream() => const Stream.empty();

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async =>
      const Result.success(null);
}
