import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/presentation/widgets/hint/qibla_message_config.dart';

class QiblaHintMessage extends StatelessWidget {
  const QiblaHintMessage({required this.qiblaMessage, super.key});
  final QiblaMessageEntity qiblaMessage;

  @override
  Widget build(BuildContext context) {
    final config = QiblaMessageConfig.fromType(qiblaMessage.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.v20),
      padding: const EdgeInsets.all(AppSpacing.v16),
      decoration: featureCardDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              qiblaMessage.message,
              style: AppTextStyles.font16W700(context, color: config.color),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.v8),
            Text(
              qiblaMessage.subMessage,
              style: AppTextStyles.font14W500Grey(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
