import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/qibla/data/models/qibla_models.dart';

class QiblaMessageConfig {
  const QiblaMessageConfig._({required this.color, required this.icon});

  factory QiblaMessageConfig.fromType(QiblaMessageType type) {
    switch (type) {
      case QiblaMessageType.perfect:
        return const QiblaMessageConfig._(
          color: AppColors.iconSuccess,
          icon: Icons.check_circle,
        );
      case QiblaMessageType.close:
        return const QiblaMessageConfig._(
          color: AppColors.iconSuccess,
          icon: Icons.adjust,
        );
      case QiblaMessageType.adjusting:
        return const QiblaMessageConfig._(
          color: AppColors.iconPrimary,
          icon: Icons.rotate_right,
        );
      case QiblaMessageType.searching:
        return const QiblaMessageConfig._(
          color: AppColors.iconWhite,
          icon: Icons.explore,
        );
    }
  }
  final Color color;
  final IconData icon;
}
