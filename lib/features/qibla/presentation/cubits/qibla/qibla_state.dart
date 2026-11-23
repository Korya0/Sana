import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';

// Guidance tone
enum QiblaGuidanceTone { normal, success, error }

sealed class QiblaState {
  const QiblaState();
}

final class QiblaInitial extends QiblaState {
  const QiblaInitial();
}

final class QiblaPermission extends QiblaState {
  const QiblaPermission();
}

final class QiblaLoading extends QiblaState {
  const QiblaLoading();
}

final class QiblaCompass extends QiblaState {
  const QiblaCompass({
    required this.qiblaEntity,
    this.heading,
    this.tilt,
    this.isLowAccuracy,
  });

  final QiblaEntity qiblaEntity;
  final double? heading;
  final double? tilt;
  final bool? isLowAccuracy;

  // Guidance title
  String get guidanceTitle {
    if (qiblaEntity.isFacing) return AppStrings.qiblaFacing;
    if (qiblaEntity.isLowAccuracy) return AppStrings.qiblaLowAccuracy;
    if (qiblaEntity.isNotFlat) return AppStrings.qiblaPlaceFlat;
    return qiblaEntity.angleDifference > 0
        ? AppStrings.qiblaTurnRight
        : AppStrings.qiblaTurnLeft;
  }

  // Guidance subtitle
  String get guidanceSubtitle {
    if (qiblaEntity.isFacing) return AppStrings.qiblaHoldInDirection;
    if (qiblaEntity.isLowAccuracy) return AppStrings.qiblaFlatSurfaceGuidance;
    if (qiblaEntity.isNotFlat) return AppStrings.qiblaFlatSurfaceGuidance;
    return AppStrings.qiblaRemainingDegrees(qiblaEntity.remainingDegrees);
  }

  // Guidance tone
  QiblaGuidanceTone get guidanceTone {
    if (qiblaEntity.isFacing) return QiblaGuidanceTone.success;
    if (qiblaEntity.isLowAccuracy || qiblaEntity.isNotFlat) {
      return QiblaGuidanceTone.error;
    }
    return QiblaGuidanceTone.normal;
  }
}

final class QiblaDenied extends QiblaState {
  const QiblaDenied(this.message);

  final String message;
}

final class QiblaFailed extends QiblaState {
  const QiblaFailed(this.message);

  final String message;
}

final class QiblaUnsupported extends QiblaState {
  const QiblaUnsupported(this.message);

  final String message;
}
