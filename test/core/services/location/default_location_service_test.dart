import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/default_location_service.dart';
import 'package:sana/core/services/location/location_platform.dart';
import 'package:sana/core/services/location/location_result.dart';
import 'package:sana/core/utils/app_logger.dart';

class _FakePlatform implements LocationPlatform {
  Object? error;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<LocationResult> getCurrentPosition() async {
    if (error != null) throw error!;
    return LocationResult(
      latitude: 21.4225,
      longitude: 39.8262,
      takenAt: DateTime.utc(2026, 11, 28),
    );
  }

  @override
  Stream<LocationResult> watchPosition() => const Stream.empty();

  @override
  Future<void> openAppSettings() async {}

  @override
  Future<void> openLocationSettings() async {}
}

void main() {
  test('getCurrentLocation returns LocationFailure when GPS cannot determine position', () async {
    final platform = _FakePlatform()..error = Exception('no fix');
    final service = DefaultLocationService(
      logger: const AppLogger(),
      platform: platform,
    );

    final result = await service.getCurrentLocation();

    expect(result, isA<FailureResult<LocationResult>>());
    expect(
      (result as FailureResult<LocationResult>).failure,
      isA<LocationFailure>(),
    );
  });
}
