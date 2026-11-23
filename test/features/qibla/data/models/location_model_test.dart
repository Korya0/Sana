import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_map_keys.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';

void main() {
  test('LocationModel roundtrips through map', () {
    const model = LocationModel(
      latitude: 30.0444,
      longitude: 31.2357,
      heading: 45.0,
    );

    final map = model.toMap();
    final restored = LocationModel.fromMap(map);

    expect(map[AppMapKeys.latitude], 30.0444);
    expect(map[AppMapKeys.longitude], 31.2357);
    expect(map[AppMapKeys.heading], 45.0);
    expect(restored, model);
    expect(restored.heading, 45.0);
  });

  test('LocationModel preserves null heading in map', () {
    const model = LocationModel(latitude: 0, longitude: 0);

    final restored = LocationModel.fromMap(model.toMap());

    expect(restored.heading, isNull);
    expect(restored.latitude, 0);
  });

  test('QiblaModel roundtrips through map', () {
    const model = QiblaModel(
      direction: 135.5,
      distanceKm: 1287.2,
      location: LocationModel(latitude: 30.0444, longitude: 31.2357),
      phoneHeading: 90.0,
    );

    final map = model.toMap();
    final restored = QiblaModel.fromMap(map);

    expect(map[AppMapKeys.direction], 135.5);
    expect(map[AppMapKeys.distanceKm], 1287.2);
    expect(map[AppMapKeys.location], isA<Map<String, dynamic>>());
    expect(map[AppMapKeys.phoneHeading], 90.0);
    expect(restored.direction, 135.5);
    expect(restored.distanceKm, 1287.2);
    expect(restored.location.latitude, 30.0444);
    expect(restored.location.longitude, 31.2357);
    expect(restored.phoneHeading, 90.0);
  });

  test('QiblaModel preserves null phoneHeading', () {
    const model = QiblaModel(
      direction: 0.0,
      distanceKm: 0.0,
      location: LocationModel(latitude: 21.4225, longitude: 39.8262),
    );

    final restored = QiblaModel.fromMap(model.toMap());

    expect(restored.phoneHeading, isNull);
  });
}
