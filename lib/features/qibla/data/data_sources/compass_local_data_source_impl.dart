import 'dart:async';
import 'dart:math' as math;

import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CompassLocalDataSourceImpl implements CompassLocalDataSource {
  CompassLocalDataSourceImpl({
    Stream<MagnetometerEvent>? magnetometerStream,
    Stream<AccelerometerEvent>? accelerometerStream,
  }) : _magnetometerStream = magnetometerStream ?? magnetometerEventStream(),
       _accelerometerStream = accelerometerStream ?? accelerometerEventStream();

  final Stream<MagnetometerEvent> _magnetometerStream;
  final Stream<AccelerometerEvent> _accelerometerStream;

  // Sensor availability
  @override
  Future<bool> hasCompassSensor() async {
    try {
      await _magnetometerStream.first.timeout(
        AppConstants.qiblaCompassProbeTimeout600ms,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // Compass stream
  @override
  Stream<CompassSensorData> onCompassChanged() {
    late StreamController<CompassSensorData> controller;
    StreamSubscription<AccelerometerEvent>? accSub;
    StreamSubscription<MagnetometerEvent>? magSub;

    double accX = 0;
    double accY = 0;
    double accZ = 9.8;
    double smoothedHeading = 0.0;
    bool hasInitialized = false;

    void updateHeading(MagnetometerEvent mag) {
      // Gravity norm
      final accNorm = math.sqrt(accX * accX + accY * accY + accZ * accZ);
      final tilt = accNorm > 0.001
          ? (math.acos((accZ.abs() / accNorm).clamp(0.0, 1.0)) * 180 / math.pi)
          : 0.0;

      // Magnetic field strength (Earth's normal range is ~25 to 65 uT)
      final magStrength = math.sqrt(
        mag.x * mag.x + mag.y * mag.y + mag.z * mag.z,
      );
      final isLowAccuracy =
          magStrength < AppConstants.qiblaMagStrengthMin15uT ||
          magStrength > AppConstants.qiblaMagStrengthMax95uT;

      double rawHeading;
      if (tilt < AppConstants.qiblaTiltTolerance) {
        // Flat orientation azimuth
        // In Android coordinates, y is towards top of phone, x is towards right
        final angle = math.atan2(-mag.x, mag.y) * 180 / math.pi;
        rawHeading = ((angle % 360) + 360) % 360;
      } else {
        // Tilt-compensated heading
        final pitch = math.atan2(-accX, math.sqrt(accY * accY + accZ * accZ));
        final roll = math.atan2(accY, accZ);

        final bx =
            mag.x * math.cos(pitch) +
            mag.y * math.sin(pitch) * math.sin(roll) +
            mag.z * math.sin(pitch) * math.cos(roll);
        final by = mag.y * math.cos(roll) - mag.z * math.sin(roll);

        final angle = math.atan2(-by, bx) * 180 / math.pi;
        rawHeading = ((angle % 360) + 360) % 360;
      }

      // Smooth heading using circular low-pass filter
      if (!hasInitialized) {
        smoothedHeading = rawHeading;
        hasInitialized = true;
      } else {
        final diff = ((rawHeading - smoothedHeading + 540) % 360) - 180;
        smoothedHeading =
            ((smoothedHeading + diff * AppConstants.qiblaHeadingSmoothing025) %
                    360 +
                360) %
            360;
      }

      controller.add(
        CompassSensorData(
          heading: smoothedHeading,
          tilt: tilt,
          isLowAccuracy: isLowAccuracy,
        ),
      );
    }

    controller = StreamController<CompassSensorData>(
      onListen: () {
        accSub = _accelerometerStream.listen((event) {
          accX = event.x;
          accY = event.y;
          accZ = event.z;
        });

        magSub = _magnetometerStream.listen(
          updateHeading,
          onError: controller.addError,
        );
      },
      onCancel: () async {
        await accSub?.cancel();
        await magSub?.cancel();
      },
    );

    return controller.stream;
  }
}
