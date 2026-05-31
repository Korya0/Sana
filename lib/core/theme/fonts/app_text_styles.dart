import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Base skeletons ────────────────────────────────────────────────────────
  static const TextStyle _fontQuran = TextStyle(
    fontFamily: AppFontsFamily.uthmanTaha,
    fontWeight: UthmanTahaFontWeight.regular,
  );
  static const TextStyle _fontApp = TextStyle(fontFamily: AppFontsFamily.cairo);

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: AppFontsFamily.cairo,
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: CairoFontWeight.bold,
  );

  static const TextStyle font24W700 = TextStyle(
    fontFamily: AppFontsFamily.cairo,
    fontSize: 24,
    fontWeight: CairoFontWeight.bold,
  );

  static TextStyle font10W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textGrey,
  );


  static TextStyle font10W500primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle font10W600primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );


  static TextStyle font12W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.regular,
    color: AppColors.textGrey,
  );

  static TextStyle font12W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 12, fontWeight: CairoFontWeight.medium);

  static TextStyle font12W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textGrey,
  );

  static TextStyle font12W500white(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textWhite,
  );

  static TextStyle font12W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textWhite,
  );

  static TextStyle font12W500primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textPrimary,
  );


  static TextStyle font12W600primaryDimmedLS05(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 12,
        fontWeight: CairoFontWeight.bold,
        color: AppColors.textPrimary.withValues(alpha: 0.85),
        letterSpacing: 0.5,
      );

  static TextStyle font12W700white(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font12W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font12W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle font12W700Black(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.scaffoldBackground,
  );

  static TextStyle font12W700Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textGrey,
  );


  static TextStyle font13W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 13,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );


  static TextStyle font14W400White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.regular,
    color: AppColors.textWhite,
  );

  static TextStyle font14W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.regular,
    color: AppColors.textGrey,
  );

  static TextStyle font14W400primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.regular,
    color: AppColors.textPrimary,
  );

  static TextStyle font14W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textGrey,
  );

  static TextStyle font14W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textWhite,
  );


  static TextStyle font14W600Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textGrey,
  );

  static TextStyle font14W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );


  static TextStyle font14W600primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle font14W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font14W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );


  static TextStyle font16W400White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.regular,
    color: AppColors.textWhite,
  );

  static TextStyle font16W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textGrey,
  );

  static TextStyle font16W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textWhite,
  );

  static TextStyle font16W500White70(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textWhite.withValues(alpha: 0.7),
  );

  static TextStyle font16W500primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textPrimary,
  );

  static TextStyle font16W600Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textGrey,
  );

  static TextStyle font16W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font16W600primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle font16W700(BuildContext context, {required Color color}) =>
      _fontApp.copyWith(
        fontSize: 16,
        fontWeight: CairoFontWeight.bold,
        color: color,
      );

  static TextStyle font16W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font16W700Black(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.bold,
    color: Colors.black,
  );

  static TextStyle font16W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );


  static TextStyle font16W700Success(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textSuccess,
  );

  static TextStyle font18W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.regular,
    color: AppColors.textGrey,
  );

  static TextStyle font18W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.medium,
    color: AppColors.textWhite,
  );

  static TextStyle font18W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font18W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font18W700WhiteLS05(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 18,
        fontWeight: CairoFontWeight.bold,
        color: AppColors.textWhite,
        letterSpacing: 0.5,
      );

  static TextStyle font18W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );


  static TextStyle font18W800White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font20W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: CairoFontWeight.regular,
    color: AppColors.textGrey,
  );

  static TextStyle font20W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle font20W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle font22W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 22,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle font24W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 24,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textPrimary,
  );


  static TextStyle font52W900White(BuildContext context) => _fontApp.copyWith(
    fontSize: 50,
    fontWeight: CairoFontWeight.bold,
    color: AppColors.textWhite,
    letterSpacing: 4,
  );

  static TextStyle font22W700primaryQuran(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 22,
        fontWeight: UthmanTahaFontWeight.regular,
        color: AppColors.textPrimary,
      );


  static TextStyle fontQuran26W700White(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 26,
        fontWeight: UthmanTahaFontWeight.regular,
        color: AppColors.textWhite,
      );

  static TextStyle font34W700primaryQuran(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 34,
        fontWeight: UthmanTahaFontWeight.regular,
        color: AppColors.textPrimary,
      );
}
