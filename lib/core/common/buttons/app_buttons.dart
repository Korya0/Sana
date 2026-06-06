import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

/// A primary button with a solid context.color.primary background.
/// Includes haptic feedback and debouncing to prevent multiple taps.
class AppPrimaryButton extends StatefulWidget {
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
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  DateTime? _lastPressTime;
  static const _debounceDuration = Duration(milliseconds: 300);

  void _handlePressed() {
    if (widget.isLoading) return;

    final now = DateTime.now();
    if (_lastPressTime != null &&
        now.difference(_lastPressTime!) < _debounceDuration) {
      return;
    }

    _lastPressTime = now;
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle =
        widget.textStyle ??
        AppTextStyles.font16W700(context).copyWith(color: context.color.textPrimary).copyWith(
          color:
              widget.foregroundColor ?? context.color.scaffoldBackgroundColor,
        );

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return SizedBox(
        width: widget.width,
        child: CupertinoButton(
          color: widget.backgroundColor ?? context.color.primary,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.v16),
          disabledColor: (widget.backgroundColor ?? context.color.error)
              .withValues(
                alpha: 0.5,
              ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          onPressed: widget.isLoading ? null : _handlePressed,
          child: _AppButtonContent(
            text: widget.text,
            icon: widget.icon,
            isLoading: widget.isLoading,
            textStyle: effectiveTextStyle,
            loadingIndicatorColor:
                widget.foregroundColor ?? context.color.scaffoldBackgroundColor,
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : _handlePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? context.color.primary,
          foregroundColor:
              widget.foregroundColor ?? context.color.scaffoldBackgroundColor,
          elevation: isIOS ? 0 : 2,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.v16),
          disabledBackgroundColor:
              (widget.backgroundColor ?? context.color.primary).withValues(
                alpha: 0.5,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          ),
        ),
        child: _AppButtonContent(
          text: widget.text,
          icon: widget.icon,
          isLoading: widget.isLoading,
          textStyle: effectiveTextStyle,
          loadingIndicatorColor:
              widget.foregroundColor ?? context.color.scaffoldBackgroundColor,
        ),
      ),
    );
  }
}

/// A secondary button with an context.color.primary outline.
/// Includes haptic feedback and debouncing to prevent multiple taps.
class AppSecondaryButton extends StatefulWidget {
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
  State<AppSecondaryButton> createState() => _AppSecondaryButtonState();
}

class _AppSecondaryButtonState extends State<AppSecondaryButton> {
  DateTime? _lastPressTime;
  static const _debounceDuration = Duration(milliseconds: 300);

  void _handlePressed() {
    if (widget.isLoading) return;

    final now = DateTime.now();
    if (_lastPressTime != null &&
        now.difference(_lastPressTime!) < _debounceDuration) {
      return;
    }

    _lastPressTime = now;
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.borderColor ?? context.color.primary;
    final effectiveTextStyle =
        widget.textStyle ??
        AppTextStyles.font16W700(context).copyWith(color: context.color.textPrimary).copyWith(
          color: widget.textColor ?? context.color.primary,
        );

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return SizedBox(
        width: widget.width,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(
              color: effectiveBorderColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.v16),
            onPressed: widget.isLoading ? null : _handlePressed,
            child: _AppButtonContent(
              text: widget.text,
              icon: widget.icon,
              isLoading: widget.isLoading,
              textStyle: effectiveTextStyle,
              loadingIndicatorColor:
                  effectiveTextStyle.color ?? context.color.primary,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      child: OutlinedButton(
        onPressed: widget.isLoading ? null : _handlePressed,
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
          text: widget.text,
          icon: widget.icon,
          isLoading: widget.isLoading,
          textStyle: effectiveTextStyle,
          loadingIndicatorColor:
              effectiveTextStyle.color ?? context.color.primary,
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
