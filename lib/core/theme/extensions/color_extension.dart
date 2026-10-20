import 'package:flutter/material.dart';
import 'package:sana/core/theme/colors/colors_dark.dart';
import 'package:sana/core/theme/colors/colors_light.dart';

class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.scaffoldBackgroundColor,
    required this.secondaryScaffoldBackgroundColor,
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconDisabled,
    required this.textBrand,
    required this.textBrandSecondary,
    required this.iconBrand,
    required this.iconBrandSecondary,
    required this.surfaceBrand,
    required this.surfaceBrandSecondary,
    required this.surfaceSelected,
    required this.surfaceDisabled,
    required this.borderBrand,
    required this.dividerColor,
    required this.actionPrimary,
    required this.actionSecondary,
    required this.textOnPrimary,
    required this.textOnSecondary,
  });

  // Backgrounds
  final Color scaffoldBackgroundColor;
  final Color secondaryScaffoldBackgroundColor;

  // Brand
  final Color primary;
  final Color secondary;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color textBrand;
  final Color textBrandSecondary;

  // Icons
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconDisabled;
  final Color iconBrand;
  final Color iconBrandSecondary;

  // Surfaces
  final Color surfaceBrand;
  final Color surfaceBrandSecondary;
  final Color surfaceSelected;
  final Color surfaceDisabled;

  // Borders
  final Color borderBrand;
  final Color dividerColor;

  // Actions
  final Color actionPrimary;
  final Color actionSecondary;
  final Color textOnPrimary;
  final Color textOnSecondary;

  @override
  ThemeExtension<MyColors> copyWith({
    Color? scaffoldBackgroundColor,
    Color? secondaryScaffoldBackgroundColor,
    Color? primary,
    Color? secondary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconDisabled,
    Color? textBrand,
    Color? textBrandSecondary,
    Color? iconBrand,
    Color? iconBrandSecondary,
    Color? surfaceBrand,
    Color? surfaceBrandSecondary,
    Color? surfaceSelected,
    Color? surfaceDisabled,
    Color? borderBrand,
    Color? dividerColor,
    Color? actionPrimary,
    Color? actionSecondary,
    Color? textOnPrimary,
    Color? textOnSecondary,
  }) => MyColors(
    scaffoldBackgroundColor:
        scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
    secondaryScaffoldBackgroundColor:
        secondaryScaffoldBackgroundColor ??
        this.secondaryScaffoldBackgroundColor,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textDisabled: textDisabled ?? this.textDisabled,
    iconPrimary: iconPrimary ?? this.iconPrimary,
    iconSecondary: iconSecondary ?? this.iconSecondary,
    iconDisabled: iconDisabled ?? this.iconDisabled,
    textBrand: textBrand ?? this.textBrand,
    textBrandSecondary: textBrandSecondary ?? this.textBrandSecondary,
    iconBrand: iconBrand ?? this.iconBrand,
    iconBrandSecondary: iconBrandSecondary ?? this.iconBrandSecondary,
    surfaceBrand: surfaceBrand ?? this.surfaceBrand,
    surfaceBrandSecondary: surfaceBrandSecondary ?? this.surfaceBrandSecondary,
    surfaceSelected: surfaceSelected ?? this.surfaceSelected,
    surfaceDisabled: surfaceDisabled ?? this.surfaceDisabled,
    borderBrand: borderBrand ?? this.borderBrand,
    dividerColor: dividerColor ?? this.dividerColor,
    actionPrimary: actionPrimary ?? this.actionPrimary,
    actionSecondary: actionSecondary ?? this.actionSecondary,
    textOnPrimary: textOnPrimary ?? this.textOnPrimary,
    textOnSecondary: textOnSecondary ?? this.textOnSecondary,
  );

  @override
  ThemeExtension<MyColors> lerp(
    covariant ThemeExtension<MyColors>? other,
    double t,
  ) {
    if (other is! MyColors) return this;
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
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t)!,
      textBrand: Color.lerp(textBrand, other.textBrand, t)!,
      textBrandSecondary: Color.lerp(
        textBrandSecondary,
        other.textBrandSecondary,
        t,
      )!,
      iconBrand: Color.lerp(iconBrand, other.iconBrand, t)!,
      iconBrandSecondary: Color.lerp(
        iconBrandSecondary,
        other.iconBrandSecondary,
        t,
      )!,
      surfaceBrand: Color.lerp(surfaceBrand, other.surfaceBrand, t)!,
      surfaceBrandSecondary: Color.lerp(
        surfaceBrandSecondary,
        other.surfaceBrandSecondary,
        t,
      )!,
      surfaceSelected: Color.lerp(surfaceSelected, other.surfaceSelected, t)!,
      surfaceDisabled: Color.lerp(surfaceDisabled, other.surfaceDisabled, t)!,
      borderBrand: Color.lerp(borderBrand, other.borderBrand, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      actionPrimary: Color.lerp(actionPrimary, other.actionPrimary, t)!,
      actionSecondary: Color.lerp(actionSecondary, other.actionSecondary, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textOnSecondary: Color.lerp(textOnSecondary, other.textOnSecondary, t)!,
    );
  }

  static const MyColors light = MyColors(
    scaffoldBackgroundColor: ColorsLight.scaffoldBackgroundColor,
    secondaryScaffoldBackgroundColor:
        ColorsLight.secondaryScaffoldBackgroundColor,
    primary: ColorsLight.primary,
    secondary: ColorsLight.secondary,
    textPrimary: ColorsLight.textPrimary,
    textSecondary: ColorsLight.textSecondary,
    textDisabled: ColorsLight.textDisabled,
    iconPrimary: ColorsLight.iconPrimary,
    iconSecondary: ColorsLight.iconSecondary,
    iconDisabled: ColorsLight.iconDisabled,
    textBrand: ColorsLight.textBrand,
    textBrandSecondary: ColorsLight.textBrandSecondary,
    iconBrand: ColorsLight.iconBrand,
    iconBrandSecondary: ColorsLight.iconBrandSecondary,
    surfaceBrand: ColorsLight.surfaceBrand,
    surfaceBrandSecondary: ColorsLight.surfaceBrandSecondary,
    surfaceSelected: ColorsLight.surfaceSelected,
    surfaceDisabled: ColorsLight.surfaceDisabled,
    borderBrand: ColorsLight.borderBrand,
    dividerColor: ColorsLight.dividerColor,
    actionPrimary: ColorsLight.actionPrimary,
    actionSecondary: ColorsLight.actionSecondary,
    textOnPrimary: ColorsLight.textOnPrimary,
    textOnSecondary: ColorsLight.textOnSecondary,
  );

  static const MyColors dark = MyColors(
    scaffoldBackgroundColor: ColorsDark.scaffoldBackgroundColor,
    secondaryScaffoldBackgroundColor:
        ColorsDark.secondaryScaffoldBackgroundColor,
    primary: ColorsDark.primary,
    secondary: ColorsDark.secondary,
    textPrimary: ColorsDark.textPrimary,
    textSecondary: ColorsDark.textSecondary,
    textDisabled: ColorsDark.textDisabled,
    iconPrimary: ColorsDark.iconPrimary,
    iconSecondary: ColorsDark.iconSecondary,
    iconDisabled: ColorsDark.iconDisabled,
    textBrand: ColorsDark.textBrand,
    textBrandSecondary: ColorsDark.textBrandSecondary,
    iconBrand: ColorsDark.iconBrand,
    iconBrandSecondary: ColorsDark.iconBrandSecondary,
    surfaceBrand: ColorsDark.surfaceBrand,
    surfaceBrandSecondary: ColorsDark.surfaceBrandSecondary,
    surfaceSelected: ColorsDark.surfaceSelected,
    surfaceDisabled: ColorsDark.surfaceDisabled,
    borderBrand: ColorsDark.borderBrand,
    dividerColor: ColorsDark.dividerColor,
    actionPrimary: ColorsDark.actionPrimary,
    actionSecondary: ColorsDark.actionSecondary,
    textOnPrimary: ColorsDark.textOnPrimary,
    textOnSecondary: ColorsDark.textOnSecondary,
  );
}
