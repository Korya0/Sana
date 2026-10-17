import 'package:flutter/material.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/colors/colors_dark.dart';
import 'package:sana/core/theme/colors/colors_light.dart';
import 'package:sana/core/theme/extensions/assets_extension.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppFontsFamily.cairo,
    scaffoldBackgroundColor: ColorsLight.scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: ColorsLight.primary,
      onPrimary: AppColorsCommon.black,
      secondary: ColorsLight.secondary,
      onSecondary: AppColorsCommon.white,
      surface: ColorsLight.scaffoldBackgroundColor,
      onSurface: ColorsLight.textPrimary,
      error: ColorsLight.error,
      onError: AppColorsCommon.white,
    ),
    extensions: const [MyColors.light, MyAssets.light],
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppFontsFamily.cairo,
    scaffoldBackgroundColor: ColorsDark.scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: ColorsDark.primary,
      onPrimary: AppColorsCommon.black,
      secondary: ColorsDark.secondary,
      onSecondary: AppColorsCommon.white,
      surface: ColorsDark.scaffoldBackgroundColor,
      onSurface: ColorsDark.textPrimary,
      error: ColorsDark.error,
      onError: AppColorsCommon.white,
    ),
    extensions: const [MyColors.dark, MyAssets.dark],
  );
}
