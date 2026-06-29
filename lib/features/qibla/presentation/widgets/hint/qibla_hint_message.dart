import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

class QiblaHintMessage extends StatelessWidget {
  const QiblaHintMessage({required this.qiblaMessage, super.key});
  final QiblaMessageEntity qiblaMessage;

  @override
  Widget build(BuildContext context) {
    final isPerfect = qiblaMessage.type == QiblaMessageType.perfect;

    Widget content = Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.v20),
      padding: const EdgeInsets.all(AppSpacing.v16),
      decoration: featureCardDecoration(
        context: context,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              qiblaMessage.message,
              style: switch (qiblaMessage.type) {
                QiblaMessageType.perfect || QiblaMessageType.close =>
                  AppTextStyles.font16W700(context).copyWith(color: context.color.secondary),
                QiblaMessageType.searching => AppTextStyles.font16W700(context).copyWith(color: context.color.textPrimary),
                _ => AppTextStyles.font16W700(context).copyWith(color: context.color.textAccent),
              },
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.v8),
            Text(
              qiblaMessage.subMessage,
              style: AppTextStyles.font14W500(context).copyWith(color: context.color.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (isPerfect) {
      content = content
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 1000.ms, color: context.color.secondary.withValues(alpha: 0.3))
          .scaleXY(end: 1.05, duration: 1000.ms, curve: Curves.easeInOutCubic);
    }

    return content;
  }
}
