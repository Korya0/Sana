import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';

class QiblaStateContent extends StatelessWidget {
  const QiblaStateContent({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.points,
    required this.buttonLabel,
    required this.onButtonPressed,
    super.key,
    this.fillHeight,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final List<String> points;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final double? fillHeight;

  @override
  Widget build(BuildContext context) => AppStateView(
    icon: icon,
    iconColor: iconColor,
    title: title,
    fillHeight: fillHeight,
    action: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Points
        _QiblaInstructionPoints(points: points),
        AppGap.h(AppSize.p32),
        AppPrimaryButton(
          label: buttonLabel,
          onPressed: onButtonPressed,
        ),
      ],
    ),
  );
}

class _QiblaInstructionPoints extends StatelessWidget {
  const _QiblaInstructionPoints({required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final point in points)
          Padding(
            padding: EdgeInsets.only(bottom: AppSize.p8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSize.p8,
                  height: AppSize.p8,
                  margin: EdgeInsets.only(top: AppSize.p4),
                  decoration: BoxDecoration(
                    color: context.color.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                AppGap.w(AppSize.p8),
                Flexible(
                  child: Text(
                    point,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.font14W500Secondary(context),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
