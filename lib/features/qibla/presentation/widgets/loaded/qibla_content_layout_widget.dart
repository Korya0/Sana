import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_kaaba_icon.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart';
import 'package:sana/features/qibla/presentation/widgets/hint/qibla_hint_message.dart';
import 'package:sana/features/qibla/presentation/widgets/map/qibla_map_widget.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_mode_toggle.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QiblaContentLayoutWidget extends StatelessWidget {
  const QiblaContentLayoutWidget({
    required this.compassData,
    required this.state,
    super.key,
  });

  final QiblaCompassDataEntity? compassData;
  final QiblaSuccess state;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Column(
      children: [
        const AppGap.h(AppSpacing.v20),
        QiblaModeToggle(
          currentMode: state.qiblaMode,
          onToggle: () {
            context.read<QiblaCubit>().toggleMode();
          },
        ),
        const AppGap.h(AppSpacing.v20),
        const AppGap.h(AppSpacing.v20),
        if (compassData != null) ...[
          QiblaHintMessage(qiblaMessage: compassData!.qiblaMessage),
          const AppGap.h(AppSpacing.v20),
        ],
        CompassKaabaIcon(
          activeColor:
              !(compassData != null) ||
              (compassData!.qiblaMessage.type == QiblaMessageType.perfect ||
                  compassData!.qiblaMessage.type == QiblaMessageType.close),
        ),
        const AppGap.h(AppSpacing.v20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v20),
            child: Skeleton.keep(
              child: state.qiblaMode == QiblaMode.compass
                  ? Center(
                      child: QiblaCompass(
                        compassData: compassData,
                        qiblaDirection: state.qiblaDirection,
                      ),
                    )
                  : QiblaMapWidget(
                      userLat: state.userLocation.latitude,
                      userLng: state.userLocation.longitude,
                      isDarkMode: isDarkMode,
                      qiblaDirection: state.qiblaDirection,
                      compassData: compassData,
                    ),
            ),
          ),
        ),
        const AppGap.h(AppSpacing.v40),
      ],
    );
  }
}
