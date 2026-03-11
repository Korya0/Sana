import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

/// A generic error widget used across the app to display error messages and retry actions.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.title,
    this.buttonText,
    this.icon,
  });

  /// The error message to display.
  final String? message;

  /// The callback to execute when the retry button is pressed.
  final VoidCallback? onRetry;

  /// Optional custom title. Defaults to [AppStrings.errorWidgetTitle].
  final String? title;

  /// Optional custom text for the retry button. Defaults to [AppStrings.tryAgain].
  final String? buttonText;

  /// Optional custom icon. Defaults to [SolarIconsBold.dangerTriangle].
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.horizontalP18 * 1.5,
            vertical: AppDesign.betweenSections18,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                icon ?? SolarIconsBold.dangerTriangle,
                size: 64,
                color: AppColors.gold