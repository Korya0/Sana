import 'package:flutter/material.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_content_layout_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerQiblaWidget extends StatelessWidget {
  const SkeletonizerQiblaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      child: QiblaContentLayoutWidget(
        compassData: null,
        qiblaDirection: 138,
        distanceToKaaba: 1377,
      ),
    );
  }
}
