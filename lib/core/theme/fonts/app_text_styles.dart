import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle _quran = TextStyle(
    fontFamily: AppFontsFamily.amiriQuran,
    fontWeight: AmiriQuranFontWeight.w400.weight,
  );
  // Cairo ships as one variable font (wght 200–900)
  static const TextStyle _app = TextStyle(fontFamily: AppFontsFamily.cairo);

  static TextStyle font12W500Secondary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f12,
    fontWeight: CairoFontWeight.w500.weight,
    color: context.color.textSecondary,
  );

  static TextStyle font12W700Brand(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f12,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textBrand,
  );

  static TextStyle font12W700Primary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f12,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textPrimary,
  );

  static TextStyle font14W500Secondary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f14,
    fontWeight: CairoFontWeight.w500.weight,
    color: context.color.textSecondary,
  );

  static TextStyle font14W700Brand(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f14,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textBrand,
  );

  // Fixed white foreground
  static TextStyle font14W700White(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f14,
    fontWeight: CairoFontWeight.w700.weight,
    color: AppColorsCommon.white,
  );

  static TextStyle font14W700Secondary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f14,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textSecondary,
  );

  static TextStyle font14W700OnPrimary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f14,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textOnPrimary,
  );

  static TextStyle font14W700Primary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f14,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textPrimary,
  );

  static TextStyle font16W500Primary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f16,
    height: AppConstants.lineHeightDialog,
    fontWeight: CairoFontWeight.w500.weight,
    color: context.color.textPrimary,
  );

  static TextStyle font16W700Primary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f16,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textPrimary,
  );

  static TextStyle font20W700Primary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f20,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textPrimary,
  );

  static TextStyle font20W700Brand(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f20,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textBrand,
  );

  static TextStyle font24W700Brand(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f24,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textBrand,
  );

  static TextStyle fontQuran24W400Primary(BuildContext context) =>
      _quran.copyWith(
        fontSize: AppSize.f24,
        height: AppConstants.lineHeightQuran,
        color: context.color.textPrimary,
      );

  // Zikr reading text — size follows the reading settings
  static TextStyle fontZikrW700Primary(BuildContext context, double size) =>
      _app.copyWith(
        fontSize: size,
        height: AppConstants.lineHeightZikr,
        fontWeight: CairoFontWeight.w700.weight,
        color: context.color.textPrimary,
      );
}
