import 'package:flutter/material.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_compass_stream_widget.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_content_layout_widget.dart';

class QiblaViewLoadedWidget extends StatelessWidget {
  const QiblaViewLoadedWidget({required this.state, super.key});

  final QiblaLoaded state;

  @override
  Widget build(BuildContext context) {
    return QiblaCompassStreamWidget(
      qiblaDirection: state.qiblaDirection,
      builder: (data) {
        return QiblaContentLayoutWidget(
          compassData: data,
          qiblaDirection: state.qiblaDirection,
          distanceToKaaba: state.distanceToKaaba,
        );
      },
    );
  }
}
