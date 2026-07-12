import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/utils/utils.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle _fontQuran = TextStyle(
    fontFamily: AppFontsFamily.amiriQuran,
    fontWeight: AmiriQuranFontWeight.w400,
  );
  static const TextStyle _fontApp = TextStyle(fontFamily: AppFontsFamily.cairo);

  static TextStyle fontQuran22W400primary(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 22.r(context),
        fontWeight: AmiriQuranFontWeight.w400,
        color: context.color.textAccent,
      );

  static TextStyle fontQuran26W400White(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 26.r(context),
        fontWeight: AmiriQuranFontWeight.w400,
        color: context.color.textPrimary,
      );

  static TextStyle fontQuran34W400primary(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 34.r(context),
        fontWeight: AmiriQuranFontWeight.w400,
        color: context.color.textAccent,
      );

  // --- Core Typography System ---
  static TextStyle font12W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 12.r(context), fontWeight: CairoFontWeight.w500);
  static TextStyle font12W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 12.r(context), fontWeight: CairoFontWeight.w700);

  static TextStyle font14W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 14.r(context), fontWeight: CairoFontWeight.w500);
  static TextStyle font14W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 14.r(context), fontWeight: CairoFontWeight.w700);

  static TextStyle font14W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14.r(context),
    fontWeight: CairoFontWeight.w700,
    
  );

  static TextStyle font16W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 16.r(context), fontWeight: CairoFontWeight.w500);
  static TextStyle font16W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 16.r(context), fontWeight: CairoFontWeight.w700);

  static TextStyle font20W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 20.r(context), fontWeight: CairoFontWeight.w700);

  static TextStyle font24W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 24.r(context), fontWeight: CairoFontWeight.w700);

  static TextStyle fontCustomW700(BuildContext context, double size) =>
      _fontApp.copyWith(fontSize: size.r(context), fontWeight: CairoFontWeight.w700);
}
