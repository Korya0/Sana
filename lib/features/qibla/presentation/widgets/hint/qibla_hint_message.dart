// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';
import 'package:sana/features/qibla/presentation/widgets/hint/qibla_message_config.dart';

/// Widget that displays hint messages to guide user towards Qibla direction
class QiblaHintMessage extends StatelessWidget {
  final double angleDifference;

  const QiblaHintMessage({super.key, required this.angleDifference});

  @override
  Widget build(BuildContext context) {
    final qiblaMessage = QiblaService.getQiblaMessage(angleDifference);
    final config = QiblaMessageConfig.getConfig(qiblaMessage.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: (20)),
      padding: const EdgeInsets.all((16)),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular((12)),
        border: Border.all(color: config.color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(config.icon, color: config.color, size: (24)),
              const SizedBox(width: (8)),
              Flexible(
                child: Text(
                  qiblaMessage.message,
                  style: AppTextStyles.font16W700White(
                    context,
                  ).copyWith(color: config.color),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: (8)),
          Text(
            qiblaMessage.subMessage,
            style: AppTextStyles.font16W500Grey(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
