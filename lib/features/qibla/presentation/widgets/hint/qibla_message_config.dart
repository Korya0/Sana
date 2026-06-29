import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

class QiblaMessageConfig {
  const QiblaMessageConfig._({required this.color, required this.icon});

  factory QiblaMessageConfig.fromType(
    BuildContext context,
    QiblaMessageType type,
  ) {
    switch (type) {
      case QiblaMessageType.perfect:
        return QiblaMessageConfig._(
          color: context.color.secondary,
          icon: Icons.check_circle,
        );
      case QiblaMessageType.close:
        return QiblaMessageConfig._(
          color: context.color.secondary,
          icon: Icons.adjust,
        );
      case QiblaMessageType.adjusting:
        return QiblaMessageConfig._(
          color: context.color.primary,
          icon: Icons.rotate_right,
        );
      case QiblaMessageType.searching:
        return QiblaMessageConfig._(
          color: context.color.textPrimary,
          icon: Icons.explore,
        );
    }
  }
  final Color color;
  final IconData icon;
}
