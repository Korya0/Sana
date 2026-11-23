import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';

QiblaEntity _entity({
  required double direction,
  double? heading,
  double tilt = 0,
  bool lowAccuracy = false,
}) => QiblaEntity(
  direction: direction,
  distanceKm: 0,
  location: const QiblaLocation(latitude: 21.4225, longitude: 39.8262),
  phoneHeading: heading,
  tilt: tilt,
  isLowAccuracy: lowAccuracy,
);

void main() {
  const entity = QiblaEntity(
    direction: 117.0,
    distanceKm: 2400.0,
    location: QiblaLocation(latitude: 30.0, longitude: 31.0),
  );

  group('QiblaState variants', () {
    test('simple variants are distinct types', () {
      expect(const QiblaInitial(), isA<QiblaState>());
      expect(const QiblaPermission(), isA<QiblaState>());
      expect(const QiblaLoading(), isA<QiblaState>());
      expect(const QiblaInitial(), isNot(const QiblaPermission()));
      expect(const QiblaLoading(), isNot(const QiblaInitial()));
    });

    test('compass keeps entity and sensor values', () {
      const state = QiblaCompass(
        qiblaEntity: entity,
        heading: 120.0,
        tilt: 12.0,
        isLowAccuracy: true,
      );

      expect(state.qiblaEntity, same(entity));
      expect(state.heading, 120.0);
      expect(state.tilt, 12.0);
      expect(state.isLowAccuracy, isTrue);
    });

    test('compass allows absent sensor values', () {
      const state = QiblaCompass(qiblaEntity: entity);

      expect(state.heading, isNull);
      expect(state.tilt, isNull);
      expect(state.isLowAccuracy, isNull);
    });

    test('message states keep their message', () {
      const denied = QiblaDenied('denied');
      const failed = QiblaFailed('failed');
      const unsupported = QiblaUnsupported('unsupported');

      expect(denied.message, 'denied');
      expect(failed.message, 'failed');
      expect(unsupported.message, 'unsupported');
      expect(denied, isNot(failed));
      expect(failed, isNot(unsupported));
    });
  });

  group('QiblaCompass guidance', () {
    test('facing shows the facing message', () {
      final state = QiblaCompass(qiblaEntity: _entity(direction: 0, heading: 0));

      expect(state.guidanceTitle, AppStrings.qiblaFacing);
      expect(state.guidanceSubtitle, AppStrings.qiblaHoldInDirection);
    });

    test('right turn shows direction and remaining degrees', () {
      final state = QiblaCompass(
        qiblaEntity: _entity(direction: 90, heading: 0),
      );

      expect(state.guidanceTitle, AppStrings.qiblaTurnRight);
      expect(state.guidanceSubtitle, AppStrings.qiblaRemainingDegrees(90));
    });

    test('left turn shows direction and remaining degrees', () {
      final state = QiblaCompass(
        qiblaEntity: _entity(direction: 270, heading: 0),
      );

      expect(state.guidanceTitle, AppStrings.qiblaTurnLeft);
      expect(state.guidanceSubtitle, AppStrings.qiblaRemainingDegrees(90));
    });

    test('missing heading yields a zero difference', () {
      final state = QiblaCompass(qiblaEntity: _entity(direction: 90));

      expect(state.guidanceTitle, AppStrings.qiblaTurnLeft);
      expect(state.guidanceSubtitle, AppStrings.qiblaRemainingDegrees(0));
    });

    test('low accuracy takes priority over turn guidance', () {
      final state = QiblaCompass(
        qiblaEntity: _entity(direction: 90, heading: 0, lowAccuracy: true),
      );

      expect(state.guidanceTitle, AppStrings.qiblaLowAccuracy);
      expect(state.guidanceSubtitle, AppStrings.qiblaFlatSurfaceGuidance);
    });

    test('tilted phone asks to be placed flat', () {
      final state = QiblaCompass(
        qiblaEntity: _entity(direction: 90, heading: 0, tilt: 30),
      );

      expect(state.guidanceTitle, AppStrings.qiblaPlaceFlat);
      expect(state.guidanceSubtitle, AppStrings.qiblaFlatSurfaceGuidance);
    });

    test('tone distinguishes success, error and normal', () {
      expect(
        QiblaCompass(qiblaEntity: _entity(direction: 0, heading: 0))
            .guidanceTone,
        QiblaGuidanceTone.success,
      );
      expect(
        QiblaCompass(
          qiblaEntity: _entity(direction: 90, heading: 0, lowAccuracy: true),
        ).guidanceTone,
        QiblaGuidanceTone.error,
      );
      expect(
        QiblaCompass(
          qiblaEntity: _entity(direction: 90, heading: 0, tilt: 30),
        ).guidanceTone,
        QiblaGuidanceTone.error,
      );
      expect(
        QiblaCompass(qiblaEntity: _entity(direction: 90, heading: 0))
            .guidanceTone,
        QiblaGuidanceTone.normal,
      );
    });
  });
}
