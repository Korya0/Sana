import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
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
      // Buttons fade as one control: border and label dim together.
      child: AppPressable(
        onPressed: onPressed,
        child: Container(
          width: expand ? double.infinity : null,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.r16),
            border: Border.all(
              color: context.color.actionPrimary,
              width: AppSize.borderWidth,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            child: Center(
              child: Text(
                label,
                maxLines: AppConstants.maxOneLine,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font14W700Brand(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
