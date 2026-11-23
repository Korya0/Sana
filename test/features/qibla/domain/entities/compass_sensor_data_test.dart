import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';

void main() {
  test('stores heading tilt and default accuracy', () {
    const data = CompassSensorData(heading: 45.5, tilt: 10);

    expect(data.heading, 45.5);
    expect(data.tilt, 10);
    expect(data.isLowAccuracy, isFalse);
  });

  test('isNotFlat uses tilt tolerance', () {
    const flat = CompassSensorData(
      heading: 0,
      tilt: AppConstants.qiblaTiltTolerance,
    );
    const tilted = CompassSensorData(
      heading: 0,
      tilt: AppConstants.qiblaTiltTolerance + 0.1,
    );

    expect(flat.isNotFlat, isFalse);
    expect(tilted.isNotFlat, isTrue);
  });

  test('low accuracy flag is preserved', () {
    const data = CompassSensorData(heading: 90, tilt: 0, isLowAccuracy: true);

    expect(data.isLowAccuracy, isTrue);
    expect(data.isNotFlat, isFalse);
  });
}
