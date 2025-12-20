// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      primaryColor: AppColors.primary,
      dividerColor: AppColors.gold.withOpacity(0.2),
      unselectedWidgetColor: AppColors.grey,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.scaffoldBackground,
        onPrimary: AppColors.textWhite,
      ),

      iconTheme: const IconThemeData(color: AppColors.iconPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.gold),
        titleTextStyle: TextStyle(
          color: AppColors.gold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Ensure Slider is Gold
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.gold,
        thumbColor: AppColors.gold,
        inactiveTrackColor: AppColors.grey,
      ),
      // Ensure Loading Indicators are Gold
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
      ),
      // Ensure Text Selection controls are Gold
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.gold,
        selectionHandleColor: AppColors.gold,
        selectionColor: Color(0x4DD4AF37), // Transparent Gold
      ),
    );
  }
}
