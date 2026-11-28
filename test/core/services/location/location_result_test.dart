import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/services/location/location_result.dart';

void main() {
  test('LocationResult keeps heading and timestamp from the reading', () {
    final takenAt = DateTime.utc(2026, 11, 28, 10, 30);

    final result = LocationResult(
      latitude: 21.4225,
      longitude: 39.8262,
      heading: 42.5,
      takenAt: takenAt,
    );

    expect(result.latitude, 21.4225);
    expect(result.longitude, 39.8262);
    expect(result.heading, 42.5);
    expect(result.takenAt, takenAt);
  });
}
