import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_gap.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';

class AppActionCard extends StatelessWidget {
  const AppActionCard({
    this.title,
    this.onTap,
    this.onLongPress,
    this.textStyle,
    this.leading,
    this.backgroundColor,
    this.borderColor,
    this.shape = BoxShape.rectangle,
    super.key,
  });

  final String? title;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final TextStyle? textStyle;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? borderColor;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(AppSpacing.radiusM),
        customBorder: shape == BoxShape.circle ? const CircleBorder() : null,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.v16,
            vertical: AppSpacing.v8,
          ),
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                context.color.scaffoldBackgroundColor.withValues(alpha: 0.8),
            shape: shape,
            borderRadius: shape == BoxShape.circle
                ? null
                : BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(
              color:
                  borderColor ??
                  context.color.textPrimary.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ?leading,
              if (leading != null && title != null)
                const AppGap.w(AppSpacing.v8),
              if (title != null)
                Text(
                  title!,
                  style:
                      textStyle ??
                      AppTextStyles.font14W500(
                        context,
                      ).copyWith(color: context.color.textPrimary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
