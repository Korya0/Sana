import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppTextStyles {
  AppTextStyles._();

  // ignore: unused_field
  static final TextStyle _quran = TextStyle(
    fontFamily: AppFontsFamily.amiriQuran,
    fontWeight: AmiriQuranFontWeight.w400.weight,
  );
  // Cairo ships as one variable font (wght 200–900)
  static const TextStyle _app = TextStyle(fontFamily: AppFontsFamily.cairo);

  static TextStyle font10W700Brand(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f10,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textBrand,
  );

  static TextStyle font10W700Secondary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f10,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textSecondary,
  );
}
