import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/location_result.dart';
import 'package:sana/core/services/location/location_service.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source_impl.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';

class _FakeLocationService implements LocationService {
  Result<LocationResult> current = Success(
    LocationResult(
      latitude: 30.0444,
      longitude: 31.2357,
      heading: 45,
      takenAt: DateTime.utc(2026, 11, 28),
    ),
  );

  @override
  Future<Result<bool>> checkPermission() async => const Success(true);

  @override
  Future<Result<bool>> requestPermission() async => const Success(true);

  @override
  Future<Result<LocationResult>> getCurrentLocation() async => current;

  @override
  Stream<LocationResult> watchLocation() => Stream.value(
        LocationResult(
          latitude: 21.4225,
          longitude: 39.8262,
          heading: 90,
          takenAt: DateTime.utc(2026, 11, 28),
        ),
      );

  @override
  Future<Result<void>> openAppSettings() async => const Success(null);

  @override
  Future<Result<void>> openLocationSettings() async => const Success(null);
}

void main() {
  late _FakeLocationService service;
  late LocationLocalDataSourceImpl dataSource;

  setUp(() {
    service = _FakeLocationService();
    dataSource = LocationLocalDataSourceImpl(service);
  });

  test('getCurrentLocation maps shared service result', () async {
    final location = await dataSource.getCurrentLocation();

    expect(location, isA<LocationModel>());
    expect(location.latitude, 30.0444);
    expect(location.longitude, 31.2357);
    expect(location.heading, 45.0);
  });

  test('getCurrentLocation throws LocationFailure when shared service fails', () async {
    service.current = const Result.failure(
      LocationFailure(message: AppStrings.qiblaFailedTitle),
    );

    expect(
      dataSource.getCurrentLocation,
      throwsA(
        isA<LocationFailure>().having(
          (failure) => failure.message,
          'message',
          AppStrings.qiblaFailedTitle,
        ),
      ),
    );
  });

  test('onLocationChanged maps streamed results', () async {
    final location = await dataSource.onLocationChanged().first;

    expect(location.latitude, 21.4225);
    expect(location.longitude, 39.8262);
    expect(location.heading, 90.0);
  });
}
