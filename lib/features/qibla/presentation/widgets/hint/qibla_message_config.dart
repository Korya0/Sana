import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/qibla/data/models/qibla_models.dart';

/// Configuration for Qibla message styling based on message type
class QiblaMessageConfig {
  final Color color;
  final IconData icon;

  const QiblaMessageConfig({required this.color, required this.icon});

  /// Get styling configuration based on message type
  static QiblaMessageConfig getConfig(QiblaMessageType type) {
    switch (type) {
      case QiblaMessageType.perfect:
        return const QiblaMessageConfig(
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case QiblaMessageType.close:
        return const QiblaMessageConfig(
          color: Colors.lightGreen,
          icon: Icons.adjust,
        );
      case QiblaMessageType.adjusting:
        return QiblaMessageConfig(
          color: AppColors.gold,
          icon: Icons.rotate_right,
        );
      case QiblaMessageType.searching:
        return QiblaMessageConfig(
          color: AppColors.textWhite,
          icon: Icons.explore,
        );
    }
  }
}
