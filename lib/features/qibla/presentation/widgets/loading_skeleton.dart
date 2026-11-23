import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_compass_content.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QiblaLoadingSkeleton extends StatelessWidget {
  const QiblaLoadingSkeleton({super.key});

  // Dummy state
  static const _state = QiblaCompass(
    qiblaEntity: QiblaEntity(
      direction: AppConstants.progressStart,
      distanceKm: AppConstants.progressStart,
      location: QiblaLocation(
        latitude: AppConstants.qiblaKaabaLatitude,
        longitude: AppConstants.qiblaKaabaLongitude,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => const IgnorePointer(
    child: Skeletonizer(
      child: QiblaCompassContent(state: _state),
    ),
  );
}
