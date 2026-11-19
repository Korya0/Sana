import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class AppIconLabelButton extends StatelessWidget {
  const AppIconLabelButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.onLongPress,
    this.semanticLabel,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return AppPressable(
      onPressed: onPressed,
      onLongPress: onLongPress,
      semanticLabel: semanticLabel ?? label,
      excludeChildSemantics: true,
      child: Container(
        height: AppSize.h64,
        constraints: BoxConstraints(minWidth: AppSize.w88),
        padding: EdgeInsets.all(AppSize.p4),
        decoration: BoxDecoration(
          color: enabled
              ? context.color.actionPrimary
              : context.color.surfaceDisabled,
          borderRadius: BorderRadius.circular(AppSize.r16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSize.icon16,
              color: enabled
                  ? context.color.iconOnPrimary
                  : context.color.iconDisabled,
            ),
            AppGap.h(AppSize.p4),
            Text(
              label,
              maxLines: AppConstants.maxOneLine,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: enabled
                  ? AppTextStyles.font11W700OnPrimary(context)
                  : AppTextStyles.font11W500Disabled(context),
            ),
          ],
        ),
      ),
    );
  }
}
