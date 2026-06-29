import 'package:flutter/material.dart';
import 'package:sana/core/theme/colors/colors_dark.dart';
import 'package:sana/core/theme/colors/colors_light.dart';
import 'package:sana/core/theme/extensions/assets_extension.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorsDark.scaffoldBackgroundColor,
      primaryColor: ColorsDark.primary,
      dividerColor: ColorsDark.primary.withValues(alpha: 0.2),
      unselectedWidgetColor: ColorsDark.textSecondary,
      colorScheme: const ColorScheme.dark(
        primary: ColorsDark.primary,
        secondary: ColorsDark.primary,
        surface: ColorsDark.scaffoldBackgroundColor,
        onPrimary: ColorsDark.textPrimary,
      ),
      iconTheme: const IconThemeData(color: ColorsDark.primary),
      extensions: const [
        MyColors.dark,
        MyAssets.dark,
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorsLight.scaffoldBackgroundColor,
      primaryColor: ColorsLight.primary,
      dividerColor: ColorsLight.primary.withValues(alpha: 0.2),
      unselectedWidgetColor: ColorsLight.textSecondary,
      colorScheme: const ColorScheme.light(
        primary: ColorsLight.primary,
        secondary: ColorsLight.primary,
        onPrimary: ColorsLight.textPrimary,
      ),
      iconTheme: const IconThemeData(color: ColorsLight.primary),
      extensions: const [
        MyColors.light,
        MyAssets.light,
      ],
    );
  }
}
