import 'package:flutter/material.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_content_layout_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerQiblaWidget extends StatelessWidget {
  const SkeletonizerQiblaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const dummyCompassData = QiblaCompassDataEntity(
      compassRotation: 0,
      arrowRotation: 0,
      angleDifference: 0,
      qiblaMessage: QiblaMessageEntity(
        message:
            'يرجى الانتظار...', // Using raw text directly as it's a dummy text
        subMessage: '',
        type: QiblaMessageType.searching,
      ),
    );

    const dummyState = QiblaSuccess(
      qiblaDirection: 0,
      distanceToKaaba: 0,
      qiblaMode: QiblaMode.compass,
      userLocation: QiblaLocationEntity(latitude: 0, longitude: 0),
    );

    return const Skeletonizer(
      child: QiblaContentLayoutWidget(
        compassData: dummyCompassData,
        state: dummyState,
      ),
    );
  }
}
