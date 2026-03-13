import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

/// A primary button with a solid [AppColors.gold] background.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.textStyle,
    this.width = double.infinity,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final TextStyle? textStyle;
  final double? width;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle =
        textStyle ??
        AppTextStyles.font16W600White(context).copyWith(
          color: foregroundColor ?? AppColors.scaffoldBackground,
        );

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.gold,
          foregroundColor: foregroundColor ?? AppColors.scaffoldBackground,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.v16),
          disabledBackgroundColor: (backgroundColor ?? AppColors.gold)
              .withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
        ),
        child: _AppButtonContent(
          text: text,
          icon: icon,
          isLoading: isLoading,
          textStyle: effectiveTextStyle,
          loadingIndicatorColor:
              foregroundColor ?? AppColors.scaffoldBackground,
        ),
      ),
    );
  }
}

/// A secondary button with an [AppColors.gold] outline.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.icon,
    this.borderColor,
    this.textColor,
    this.textStyle,
    this.isLoading = false,
    this.width = double.infinity,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.gold;
    final effectiveTextStyle =
        textStyle ??
        AppTextStyles.font16W600White(context).copyWith(
          color: textColor ?? AppColors.gold,
        );

    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextStyle.color,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.v16),
          side: BorderSide(
            color: effectiveBorderColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
        ),
        child: _AppButtonContent(
          text: text,
          icon: icon,
          isLoading: isLoading,
          textStyle: effectiveTextStyle,
          loadingIndicatorColor: effectiveTextStyle.color ?? AppColors.gold,
        ),
      ),
    );
  }
}

/// Internal widget to handle common button content (Text, Icon, Loading indicator).
class _AppButtonContent extends StatelessWidget {
  const _AppButtonContent({
    required this.text,
    required this.isLoading,
    required this.textStyle,
    required this.loadingIndicatorColor,
    this.icon,
  });

  final String text;
  final IconData? icon;
  final bool isLoading;
  final TextStyle textStyle;
  final Color loadingIndicatorColor;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(loadingIndicatorColor),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.v8),
        ],
        Text(text, style: textStyle),
      ],
    );
  }
}
