import 'package:flutter/material.dart';
import 'package:sana/core/theme/colors/colors_dark.dart';
import 'package:sana/core/theme/colors/colors_light.dart';

class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.scaffoldBackgroundColor,
    required this.secondaryScaffoldBackgroundColor,
    required this.primary,
    required this.secondary,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
    required this.textAccent,
    required this.primarySubtle,
    required this.scaffoldBackgroundSubtle,
  });

  final Color scaffoldBackgroundColor;
  final Color secondaryScaffoldBackgroundColor;
  final Color primary;
  final Color secondary;
  final Color error;
  final Color textPrimary;
  final Color textSecondary;
  final Color textAccent;
  final Color primarySubtle;
  final Color scaffoldBackgroundSubtle;

  @override
  ThemeExtension<MyColors> copyWith({
    Color? scaffoldBackgroundColor,
    Color? secondaryScaffoldBackgroundColor,
    Color? primary,
    Color? secondary,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
    Color? textAccent,
    Color? primarySubtle,
    Color? scaffoldBackgroundSubtle,
  }) {
    return MyColors(
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      secondaryScaffoldBackgroundColor:
          secondaryScaffoldBackgroundColor ??
          this.secondaryScaffoldBackgroundColor,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textAccent: textAccent ?? this.textAccent,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      scaffoldBackgroundSubtle:
          scaffoldBackgroundSubtle ?? this.scaffoldBackgroundSubtle,
    );
  }

  @override
  ThemeExtension<MyColors> lerp(
    covariant ThemeExtension<MyColors>? other,
    double t,
  ) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      scaffoldBackgroundColor: Color.lerp(
        scaffoldBackgroundColor,
        other.scaffoldBackgroundColor,
        t,
      )!,
      secondaryScaffoldBackgroundColor: Color.lerp(
        secondaryScaffoldBackgroundColor,
        other.secondaryScaffoldBackgroundColor,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textAccent: Color.lerp(textAccent, other.textAccent, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      scaffoldBackgroundSubtle: Color.lerp(
        scaffoldBackgroundSubtle,
        other.scaffoldBackgroundSubtle,
        t,
      )!,
    );
  }

  static const MyColors dark = MyColors(
    scaffoldBackgroundColor: ColorsDark.scaffoldBackgroundColor,
    secondaryScaffoldBackgroundColor:
        ColorsDark.secondaryScaffoldBackgroundColor,
    primary: ColorsDark.primary,
    secondary: ColorsDark.secondary,
    error: ColorsDark.error,
    textPrimary: ColorsDark.textPrimary,
    textSecondary: ColorsDark.textSecondary,
    textAccent: ColorsDark.textAccent,
    primarySubtle: Color(0x4DD4AF37),
    scaffoldBackgroundSubtle: Color(0x4D000000),
  );

  static const MyColors light = MyColors(
    scaffoldBackgroundColor: ColorsLight.scaffoldBackgroundColor,
    secondaryScaffoldBackgroundColor:
        ColorsLight.secondaryScaffoldBackgroundColor,
    primary: ColorsLight.primary,
    secondary: ColorsLight.secondary,
    error: ColorsLight.error,
    textPrimary: ColorsLight.textPrimary,
    textSecondary: ColorsLight.textSecondary,
    textAccent: ColorsLight.textAccent,
    primarySubtle: Color(0x4DD4AF37),
    scaffoldBackgroundSubtle: Color(0x4DFFFFFF),
  );
}
