import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/qibla/constants/qibla_ui_constants.dart';

class CompassKaabaIcon extends StatelessWidget {
  const CompassKaabaIcon({required this.activeColor, super.key});
  final bool activeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.v16),
      decoration: featureCardDecoration(
        context: context,
        shape: BoxShape.circle,
      ),
      child: Icon(
        FlutterIslamicIcons.solidKaaba,
        color: activeColor ? context.color.secondary : context.color.primary,
        size: QiblaUiConstants.kaabaIconSize.r(context),
      ),
    );
  }
}
