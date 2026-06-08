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

  // --- Core Typography System ---
  static TextStyle font12W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 12, fontWeight: CairoFontWeight.w500);
  static TextStyle font12W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 12, fontWeight: CairoFontWeight.w700);

  static TextStyle font14W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 14, fontWeight: CairoFontWeight.w500);
  static TextStyle font14W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 14, fontWeight: CairoFontWeight.w700);

  static TextStyle font14W700White(BuildContext context) =>
      _fontApp.copyWith(fontSize: 14, fontWeight: CairoFontWeight.w700, color: Colors.white);

  static TextStyle font16W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 16, fontWeight: CairoFontWeight.w500);
  static TextStyle font16W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 16, fontWeight: CairoFontWeight.w700);

  static TextStyle font20W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 20, fontWeight: CairoFontWeight.w700);

  static TextStyle font24W700(BuildContext context) =>
      _fontApp.copyWith(fontSize: 24, fontWeight: CairoFontWeight.w700);
}
