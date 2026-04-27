import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class AppTextStyles {
  static const TextStyle _fontQuran = TextStyle(
    fontFamily: AppFontsFamily.uthmanTaha,
  );
  static const TextStyle _fontApp = TextStyle(fontFamily: AppFontsFamily.cairo);

  static TextStyle font15W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );
  static TextStyle font12W700white(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle font12W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static TextStyle font14W400White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite,
  );

  static TextStyle font32W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // font12W400Grey
  static TextStyle font12W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );

  static TextStyle font50W900White(BuildContext context) => _fontApp.copyWith(
    fontSize: 50,
    fontWeight: FontWeight.w900,
    color: AppColors.textWhite,
    letterSpacing: 4,
  );

  static TextStyle font18W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle font18W700WhiteLS05(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
        letterSpacing: 0.5,
      );

  static TextStyle font16W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static TextStyle font16W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font16W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle font16W600Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textGrey,
  );

  static TextStyle font13W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font14W600primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle font16W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle font10W500primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle font16W600primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle font40W900primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 6,
  );

  static TextStyle font26W900primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  static TextStyle font26W900Primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 2,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  static TextStyle font12W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle font12W500white(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font12W500primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle font12W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font18W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle font18W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font12W500primaryDimmed(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle font12W600primaryDimmedLS05(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary.withValues(alpha: 0.85),
        letterSpacing: 0.5,
      );

  static TextStyle font12W500WhiteDimmed(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textWhite,
      );

  static TextStyle font10W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font16W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle font14W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle font13W700white(BuildContext context) => _fontApp.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );
  static TextStyle font14W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle font12W700Black(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.scaffoldBackground,
  );

  static TextStyle font22W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle font15W600WhiteH18(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite.withValues(alpha: 0.95),
      );

  static TextStyle font16W700primaryBold(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle font10W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static TextStyle font14W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle font14W600WhiteH18(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      );

  static TextStyle font13W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle font18W700GreyH12(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textGrey,
  );

  static TextStyle font20W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle font20W700primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle font20W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );

  static TextStyle font14W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static TextStyle font14W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font14W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );

  static TextStyle font18W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );

  static TextStyle font26W700primaryQuran(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle fontQuran26W700White(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      );

  static TextStyle font14W400primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle font16W400White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite,
  );

  static TextStyle font12W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle font10W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle font12W700Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textGrey,
  );
  static TextStyle font18W800White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
  );

  static TextStyle font16W700(BuildContext context, {required Color color}) =>
      _fontApp.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      );
}
