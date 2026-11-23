import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source_impl.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  late StreamController<MagnetometerEvent> magnetometerController;
  late StreamController<AccelerometerEvent> accelerometerController;
  late CompassLocalDataSourceImpl dataSource;

  setUp(() {
    magnetometerController = StreamController<MagnetometerEvent>();
    accelerometerController = StreamController<AccelerometerEvent>();
    dataSource = CompassLocalDataSourceImpl(
      magnetometerStream: magnetometerController.stream,
      accelerometerStream: accelerometerController.stream,
    );
  });

  tearDown(() {
    unawaited(magnetometerController.close());
    unawaited(accelerometerController.close());
  });

  MagnetometerEvent mag(double x, double y, double z) =>
      MagnetometerEvent(x, y, z, DateTime.now());

  AccelerometerEvent acc(double x, double y, double z) =>
      AccelerometerEvent(x, y, z, DateTime.now());

  test('hasCompassSensor returns true when magnetometer emits', () async {
    magnetometerController.add(mag(0, 30, 0));

    final hasSensor = await dataSource.hasCompassSensor();

    expect(hasSensor, isTrue);
  });

  test('hasCompassSensor returns false on timeout', () async {
    final neverController = StreamController<MagnetometerEvent>();
    addTearDown(() => unawaited(neverController.close()));
    final never = CompassLocalDataSourceImpl(
      magnetometerStream: neverController.stream,
      accelerometerStream: accelerometerController.stream,
    );

    final hasSensor = await never.hasCompassSensor();

    expect(hasSensor, isFalse);
    expect(
      AppConstants.qiblaCompassProbeTimeout600ms,
      const Duration(milliseconds: 600),
    );
  });

  test('hasCompassSensor returns false on stream error', () async {
    magnetometerController.addError(StateError('sensor unavailable'));

    final hasSensor = await dataSource.hasCompassSensor();

    expect(hasSensor, isFalse);
  });

  test('onCompassChanged emits heading and smooths corrections', () async {
    final stream = dataSource.onCompassChanged();
    final emissions = stream.take(2).toList();
    await Future<void>.delayed(Duration.zero);

    accelerometerController.add(acc(0, 0, 9.8));
    magnetometerController.add(mag(0, 30, 0));
    await Future<void>.delayed(Duration.zero);
    magnetometerController.add(mag(30, 0, 0));

    final data = await emissions;
    expect(data.first.heading, closeTo(0, 0.001));
    expect(data.first.tilt, closeTo(0, 0.001));
    expect(data.first.isLowAccuracy, isFalse);
    expect(data.last.heading, closeTo(337.5, 0.001));
  });

  test('onCompassChanged flags low magnetic strength', () async {
    final emission = dataSource.onCompassChanged().first;
    await Future<void>.delayed(Duration.zero);

    accelerometerController.add(acc(0, 0, 9.8));
    magnetometerController.add(mag(100, 0, 0));

    final data = await emission;
    expect(data.isLowAccuracy, isTrue);
    expect(data.heading, closeTo(270, 0.001));
  });

  test('onCompassChanged computes tilt for tilted device', () async {
    final emission = dataSource.onCompassChanged().first;
    await Future<void>.delayed(Duration.zero);

    accelerometerController.add(acc(9.8, 0, 0));
    magnetometerController.add(mag(0, 30, 0));

    final data = await emission;
    expect(data.tilt, closeTo(90, 0.001));
    expect(data.isNotFlat, isTrue);
    expect(data.isLowAccuracy, isFalse);
  });

  test('onCompassChanged forwards magnetometer errors', () async {
    final stream = dataSource.onCompassChanged();
    final error = expectLater(stream, emitsError(isA<StateError>()));
    await Future<void>.delayed(Duration.zero);

    magnetometerController.addError(StateError('read failed'));

    await error;
  });

  test('onCompassChanged cancels both subscriptions', () async {
    final subscription = dataSource.onCompassChanged().listen((_) {});
    await Future<void>.delayed(Duration.zero);

    expect(magnetometerController.hasListener, isTrue);
    expect(accelerometerController.hasListener, isTrue);

    await subscription.cancel();
    await Future<void>.delayed(Duration.zero);

    expect(magnetometerController.hasListener, isFalse);
    expect(accelerometerController.hasListener, isFalse);
  });

  test('emitted data is a CompassSensorData value', () async {
    final emission = dataSource.onCompassChanged().first;
    await Future<void>.delayed(Duration.zero);

    accelerometerController.add(acc(0, 0, 9.8));
    magnetometerController.add(mag(0, 30, 0));

    final data = await emission;
    expect(data, isA<CompassSensorData>());
    expect(data.tilt, lessThan(AppConstants.qiblaTiltTolerance));
  });
}
