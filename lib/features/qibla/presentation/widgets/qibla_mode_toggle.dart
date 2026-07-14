import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';

class QiblaModeToggle extends StatelessWidget {
  const QiblaModeToggle({
    required this.currentMode,
    required this.onToggle,
    super.key,
  });

  final QiblaMode currentMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isMap = currentMode == QiblaMode.map;

    return Container(
      decoration: BoxDecoration(
        color: context.color.secondaryScaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(30.r(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QiblaModeToggleButton(
            title: AppStrings.compassMode,
            icon: Icons.explore_outlined,
            isSelected: !isMap,
            onToggle: onToggle,
          ),
          _QiblaModeToggleButton(
            title: AppStrings.mapMode,
            icon: Icons.map_outlined,
            isSelected: isMap,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}

class _QiblaModeToggleButton extends StatelessWidget {
  const _QiblaModeToggleButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onToggle,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: AppConstants.animationNormal250ms,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.v20,
          vertical: AppSpacing.v10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.color.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r(context)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSpacing.s20.r(context),
              color: isSelected
                  ? context.color.textPrimary
                  : context.color.textSecondary,
            ),
            const AppGap.w(AppSpacing.v8),
            Text(
              title,
              style: AppTextStyles.font14W500(context).copyWith(
                color: isSelected
                    ? context.color.textPrimary
                    : context.color.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
