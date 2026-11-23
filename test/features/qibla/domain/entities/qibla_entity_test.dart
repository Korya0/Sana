import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';

void main() {
  QiblaEntity entity({
    double direction = 100,
    double distanceKm = 1200,
    double? phoneHeading = 100,
    double tilt = 0,
    bool isLowAccuracy = false,
  }) => QiblaEntity(
    direction: direction,
    distanceKm: distanceKm,
    location: const QiblaLocation(latitude: 30.0444, longitude: 31.2357),
    phoneHeading: phoneHeading,
    tilt: tilt,
    isLowAccuracy: isLowAccuracy,
  );

  test('angleDifference is zero without phone heading', () {
    expect(entity(phoneHeading: null).angleDifference, 0);
  });

  test('angleDifference handles positive and negative offsets', () {
    expect(entity(direction: 90, phoneHeading: 60).angleDifference, 30);
    expect(entity(direction: 60, phoneHeading: 90).angleDifference, -30);
  });

  test('angleDifference wraps at 0, 180 and 360', () {
    expect(entity(direction: 0, phoneHeading: 360).angleDifference, 0);
    expect(entity(direction: 350, phoneHeading: 10).angleDifference, -20);
    expect(entity(direction: 180, phoneHeading: 0).angleDifference, -180);
    expect(entity(direction: 360, phoneHeading: 0).angleDifference, 0);
  });

  test('remainingDegrees is the rounded magnitude', () {
    expect(entity(direction: 90, phoneHeading: 60).remainingDegrees, 30);
    expect(entity(direction: 60, phoneHeading: 90).remainingDegrees, 30);
    expect(entity(direction: 100, phoneHeading: 94).remainingDegrees, 6);
  });

  test('isFacing respects tolerance boundaries', () {
    expect(entity(phoneHeading: 94).isFacing, isTrue);
    expect(entity(phoneHeading: 106).isFacing, isTrue);
    expect(entity(phoneHeading: 93).isFacing, isFalse);
    expect(entity(phoneHeading: 107).isFacing, isFalse);
    expect(
      AppConstants.qiblaFacingTolerance,
      6,
    );
  });

  test('isFacing rejects low accuracy, tilt and null heading', () {
    expect(entity(isLowAccuracy: true).isFacing, isFalse);
    expect(
      entity(tilt: AppConstants.qiblaTiltTolerance + 1).isFacing,
      isFalse,
    );
    expect(entity(phoneHeading: null).isFacing, isFalse);
  });

  test('isNotFlat uses tilt tolerance', () {
    expect(entity(tilt: AppConstants.qiblaTiltTolerance).isNotFlat, isFalse);
    expect(
      entity(tilt: AppConstants.qiblaTiltTolerance + 0.1).isNotFlat,
      isTrue,
    );
  });

  test('copyWith updates only supplied fields', () {
    final original = entity();

    final copy = original.copyWith(
      direction: 200,
      distanceKm: 999,
      location: const QiblaLocation(latitude: 1, longitude: 2),
      phoneHeading: 50,
      tilt: 10,
      isLowAccuracy: true,
    );

    expect(copy.direction, 200);
    expect(copy.distanceKm, 999);
    expect(copy.location.latitude, 1);
    expect(copy.phoneHeading, 50);
    expect(copy.tilt, 10);
    expect(copy.isLowAccuracy, isTrue);
    expect(original.direction, 100);
    expect(original.isLowAccuracy, isFalse);
  });

  test('equality and hashCode compare all fields', () {
    final first = entity();
    final same = entity();
    final different = entity(direction: 101);

    expect(first == same, isTrue);
    expect(first.hashCode, same.hashCode);
    expect(first == different, isFalse);
    expect(first.hashCode == different.hashCode, isFalse);
  });

  test('QiblaLocation copies and compares coordinates', () {
    const location = QiblaLocation(latitude: 30.0444, longitude: 31.2357);

    expect(location.copyWith(latitude: 1).latitude, 1);
    expect(location.copyWith(longitude: 2).longitude, 2);
    expect(location.copyWith(), location);
    expect(location.toMap()['latitude'], 30.0444);
    expect(location == const QiblaLocation(latitude: 30.0444, longitude: 31.2357), isTrue);
    expect(location == const QiblaLocation(latitude: 0, longitude: 0), isFalse);
  });
}
