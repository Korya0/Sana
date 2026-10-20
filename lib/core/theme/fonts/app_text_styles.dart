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
  static const TextStyle _app = TextStyle(fontFamily: AppFontsFamily.cairo);

  // Primary
  static TextStyle font24W700primary(BuildContext context) => _app.copyWith(
    fontSize: AppSize.f24,
    fontWeight: CairoFontWeight.w700.weight,
    color: context.color.textPrimary,
  );
}
