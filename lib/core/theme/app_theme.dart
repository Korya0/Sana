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
    dividerColor: ColorsLight.dividerColor,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
      primary: ColorsLight.primary,
      onPrimary: ColorsLight.textOnPrimary,
      primaryContainer: ColorsLight.surfaceBrand,
      onPrimaryContainer: ColorsLight.textOnPrimary,
      secondary: ColorsLight.secondary,
      onSecondary: ColorsLight.textOnSecondary,
      secondaryContainer: ColorsLight.surfaceBrandSecondary,
      onSecondaryContainer: ColorsLight.textOnSecondary,
      error: AppColorsCommon.errorColor,
      onError: ColorsLight.textOnPrimary,
      errorContainer: AppColorsCommon.errorColor,
      onErrorContainer: ColorsLight.textOnPrimary,
      surface: ColorsLight.secondaryScaffoldBackgroundColor,
      onSurface: ColorsLight.textPrimary,
      onSurfaceVariant: ColorsLight.textSecondary,
      outline: ColorsLight.dividerColor,
      outlineVariant: ColorsLight.dividerColor,
      inverseSurface: ColorsLight.textPrimary,
      onInverseSurface: ColorsLight.scaffoldBackgroundColor,
      inversePrimary: ColorsDark.primary,
      surfaceTint: ColorsLight.primary,
      shadow: Colors.black,
      scrim: Colors.black,
    ),
    extensions: const [
      MyColors.light,
      MyAssets.light,
    ],
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppFontsFamily.cairo,
    scaffoldBackgroundColor: ColorsDark.scaffoldBackgroundColor,
    dividerColor: ColorsDark.dividerColor,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: ColorsDark.primary,
      onPrimary: ColorsDark.textOnPrimary,
      primaryContainer: ColorsDark.surfaceBrand,
      onPrimaryContainer: ColorsDark.textOnPrimary,
      secondary: ColorsDark.secondary,
      onSecondary: ColorsDark.textOnSecondary,
      secondaryContainer: ColorsDark.surfaceBrandSecondary,
      onSecondaryContainer: ColorsDark.textOnSecondary,
      error: AppColorsCommon.errorColor,
      onError: ColorsDark.textOnPrimary,
      errorContainer: AppColorsCommon.errorColor,
      onErrorContainer: ColorsDark.textOnPrimary,
      surface: ColorsDark.secondaryScaffoldBackgroundColor,
      onSurface: ColorsDark.textPrimary,
      onSurfaceVariant: ColorsDark.textSecondary,
      outline: ColorsDark.dividerColor,
      outlineVariant: ColorsDark.dividerColor,
      inverseSurface: ColorsDark.textPrimary,
      onInverseSurface: ColorsDark.scaffoldBackgroundColor,
      inversePrimary: ColorsLight.primary,
      surfaceTint: ColorsDark.primary,
      shadow: Colors.black,
      scrim: Colors.black,
    ),
    extensions: const [
      MyColors.dark,
      MyAssets.dark,
    ],
  );
}
