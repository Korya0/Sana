import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/get_location_stream_use_case.dart';

void main() {
  test('delegates and emits locations', () async {
    final repository = _FakeRepository();

    final data = await GetLocationStreamUseCase(repository)().first;

    expect(data.latitude, 21.4225);
    expect(data.longitude, 39.8262);
    expect(data.heading, 88.0);
    expect(repository.callCount, 1);
  });

  test('forwards stream errors', () async {
    final repository = _FakeRepository(failing: true);

    final emissions = GetLocationStreamUseCase(repository)().toList();

    await expectLater(emissions, throwsA(isA<StateError>()));
    expect(repository.callCount, 1);
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({this.failing = false});

  final bool failing;
  int callCount = 0;

  @override
  Stream<LocationModel> getLocationStream() {
    callCount++;
    if (failing) {
      return Stream.error(StateError('stream failure'));
    }
    return Stream.value(
      const LocationModel(latitude: 21.4225, longitude: 39.8262, heading: 88),
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
  Stream<CompassSensorData> getCompassStream() => const Stream.empty();

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async =>
      const Result.success(null);
}
