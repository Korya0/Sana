import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';

void main() {
  test('exposes sensor availability and stream surface', () async {
    final CompassLocalDataSource source = _FakeCompassLocalDataSource();

    expect(await source.hasCompassSensor(), isTrue);
    expect((await source.onCompassChanged().first).heading, 42.0);
  });
}

class _FakeCompassLocalDataSource implements CompassLocalDataSource {
  @override
  Future<bool> hasCompassSensor() async => true;

  @override
  Stream<CompassSensorData> onCompassChanged() => Stream.value(
    const CompassSensorData(heading: 42, tilt: 5),
  );
}
