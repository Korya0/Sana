import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.textStyle,
    this.padding,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final height = AppSize.h48 < AppConstants.minTapTarget
        ? AppConstants.minTapTarget
        : AppSize.h48;
    final enabled = onPressed != null;

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
              child: Text(
                label,
                maxLines: AppConstants.maxOneLine,
                overflow: TextOverflow.ellipsis,
                style: textStyle ?? AppTextStyles.font14W700Brand(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

