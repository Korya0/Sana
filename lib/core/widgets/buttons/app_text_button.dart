import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.textStyle,
    this.padding,
    this.expand = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final bool expand;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final height = AppSize.h48 < AppConstants.minTapTarget
        ? AppConstants.minTapTarget
        : AppSize.h48;
    final enabled = onPressed != null;
    final style = textStyle ?? AppTextStyles.font14W700Primary(context);

    return Opacity(
      opacity: enabled
          ? AppConstants.opacityFull
          : AppConstants.opacityDisabled,
      child: AppPressable(
        onPressed: onPressed,
        child: SizedBox(
          width: expand ? double.infinity : null,
          height: height,
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.p12),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  if (icon != null) ...[
                    Icon(icon, size: AppSize.icon16, color: style.color),
                    AppGap.w(AppSize.p8),
                  ],

                  // Label
                  Flexible(
                    child: Text(
                      label,
                      maxLines: AppConstants.maxOneLine,
                      overflow: TextOverflow.ellipsis,
                      style: style,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
