import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart'
    as compass_widget;
import 'package:sana/features/qibla/presentation/widgets/message_card.dart';

class QiblaCompassContent extends StatelessWidget {
  const QiblaCompassContent({
    required this.state,
    super.key,
  });

  final QiblaCompass state;

  @override
  Widget build(BuildContext context) {
    final qibla = state.qiblaEntity;

    return Column(
      children: [
        // Message card
        Padding(
          padding: AppSize.shp,
          child: QiblaMessageCard(
            title: state.guidanceTitle,
            subtitle: state.guidanceSubtitle,
            tone: state.guidanceTone,
          ),
        ),

        AppGap.h(AppSize.p24),

        // Compass dial
        Expanded(
          child: compass_widget.QiblaCompass(
            direction: qibla.direction,
            phoneHeading: qibla.phoneHeading,
            isFacing: qibla.isFacing,
          ),
        ),

        AppGap.h(AppSize.sbp),
      ],
    );
  }
}
