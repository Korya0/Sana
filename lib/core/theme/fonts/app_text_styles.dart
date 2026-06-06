import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle _fontQuran = TextStyle(
    fontFamily: AppFontsFamily.amiriQuran,
    fontWeight: AmiriQuranFontWeight.w400,
  );
  static const TextStyle _fontApp = TextStyle(fontFamily: AppFontsFamily.cairo);

  static TextStyle fontQuran22W400primary(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 22,
        fontWeight: AmiriQuranFontWeight.w400,
        color: context.color.textAccent,
      );

  static TextStyle font14W700(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w700,
  );

  static TextStyle fontQuran26W400White(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 26,
        fontWeight: AmiriQuranFontWeight.w400,
        color: context.color.textPrimary,
      );

  static TextStyle fontQuran34W400primary(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 34,
        fontWeight: AmiriQuranFontWeight.w400,
        color: context.color.textAccent,
      );

  static TextStyle appBarTitle(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font10W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textSecondary,
  );

  static TextStyle font10W500primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textAccent,
  );

  static TextStyle font10W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font12W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w400,
    color: context.color.textSecondary,
  );

  static TextStyle font11W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 11, fontWeight: CairoFontWeight.w700);

  static TextStyle font12W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textSecondary,
  );

  static TextStyle font12W500(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w500,
  );

  static TextStyle font12W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textPrimary,
  );

  static TextStyle font12W700primaryDimmedLS05(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 12,
        fontWeight: CairoFontWeight.w700,
        color: context.color.textAccent.withValues(alpha: 0.85),
        letterSpacing: 0.5,
      );

  static TextStyle font12W700white(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
  );

  static TextStyle font12W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
  );

  static TextStyle font12W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font12W700Black(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w700,
    color: context.color.scaffoldBackgroundColor,
  );

  static TextStyle font12W700Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textSecondary,
  );

  static TextStyle font13W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 13,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
  );

  static TextStyle font14W400White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w400,
    color: context.color.textPrimary,
  );

  static TextStyle font14W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w400,
    color: context.color.textSecondary,
  );

  static TextStyle font14W400primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w400,
    color: context.color.textAccent,
  );

  static TextStyle font14W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textSecondary,
  );

  static TextStyle font14W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textPrimary,
  );

  static TextStyle font14W700Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textSecondary,
  );

  static TextStyle font14W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
  );

  static TextStyle font14W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font16W400White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w400,
    color: context.color.textPrimary,
  );

  static TextStyle font16W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textSecondary,
  );

  static TextStyle font16W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textPrimary,
  );

  static TextStyle font16W500White70(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textPrimary.withValues(alpha: 0.7),
  );

  static TextStyle font16W500primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textAccent,
  );

  static TextStyle font16W700Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textSecondary,
  );

  static TextStyle font16W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
  );

  static TextStyle font16W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font16W700(
    BuildContext context,
  ) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w700,
  );

  static TextStyle font16W700Success(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: CairoFontWeight.w700,
    color: context.color.secondary,
  );

  static TextStyle font18W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.w400,
    color: context.color.textSecondary,
  );

  static TextStyle font18W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.w500,
    color: context.color.textPrimary,
  );

  static TextStyle font18W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
  );

  static TextStyle font18W700WhiteLS05(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 18,
        fontWeight: CairoFontWeight.w700,
        color: context.color.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle font18W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font20W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: CairoFontWeight.w400,
    color: context.color.textSecondary,
  );

  static TextStyle font20W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
  );

  static TextStyle font20W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font22W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 22,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font24W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 24,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textAccent,
  );

  static TextStyle font50W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 50,
    fontWeight: CairoFontWeight.w700,
    color: context.color.textPrimary,
    letterSpacing: 4,
  );
}
