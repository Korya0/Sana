import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class PrayerTimelineNode extends StatelessWidget {
  const PrayerTimelineNode({required this.isNext, super.key});
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    if (isNext) {
      return _buildNode(context, isAnimated: true);
    }
    return _buildNode(context, isAnimated: false);
  }

  Widget _buildNode(BuildContext context, {required bool isAnimated}) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getNodeColor(isAnimated),
        border: Border.all(color: _getBorderColor(isAnimated), width: 2),
        boxShadow: isAnimated ? _getBoxShadow() : null,
      ),
    );
  }

  Color _getNodeColor(bool isAnimated) {
    if (isAnimated) {
      return AppColors.primary;
    } else {
      return AppColors.secondaryBackground;
    }
  }

  Color _getBorderColor(bool isAnimated) {
    if (isAnimated) {
      return AppColors.primary;
    } else {
      return AppColors.grey.withValues(alpha: 0.3);
    }
  }

  List<BoxShadow> _getBoxShadow() {
    return [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.6),
        blurRadius: 12,
        spreadRadius: 3,
      ),
    ];
  }
}
