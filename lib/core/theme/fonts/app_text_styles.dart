import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class AppTextStyles {
  static const TextStyle _fontQuran = TextStyle(
    fontFamily: AppFontsFamily.uthmanTaha,
  );
  static const TextStyle _fontApp = TextStyle(fontFamily: AppFontsFamily.cairo);

  //font15W700White

  static TextStyle font15W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );
  // uthmanTaha font32W700Gold
  static TextStyle font32W700Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
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

  static TextStyle font16W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  // font16W500White

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

  // font16W600Grey
  static TextStyle font16W600Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textGrey,
  );

  static TextStyle font12W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static TextStyle font13W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font12W600primary(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // Prayer Feature Styles
  static TextStyle font16W600Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
  );

  static TextStyle font40W900Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.gold,
    letterSpacing: 6,
    height: 1,
  );

  static TextStyle font26W900Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AppColors.gold,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  // font12W500
  static TextStyle font12W500(BuildContext context) =>
      _fontApp.copyWith(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle font12W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font18W700Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
  );

  static TextStyle font18W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle font12W500GoldDimmed(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.gold,
      );

  static TextStyle font12W500WhiteDimmed(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textWhite,
      );

  static TextStyle font16W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle font12W500Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.gold,
  );

  static TextStyle font10W500White(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle font12W700Black(BuildContext context) => _fontApp.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.scaffoldBackground,
  );

  // Azkar Feature Styles
  static TextStyle font22W700Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
  );

  static TextStyle font15W600WhiteH18(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.white.withValues(alpha: 0.95),
        height: 1.8,
      );

  static TextStyle font16W700GoldBold(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.gold,
      );

  static TextStyle font10W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  static TextStyle font14W600White(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // font20W700White
  static TextStyle font20W700White(BuildContext context) => _fontApp.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // font14W600Gold
  static TextStyle font14W600Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
  );

  static TextStyle font14W500Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  static TextStyle font14W400Grey(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // Asma Ul Husna Feature Styles
  static TextStyle font26W700GoldQuran(BuildContext context) =>
      _fontQuran.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.gold,
      );

  static TextStyle font16W700Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle font14W400WhiteHeight16(BuildContext context) =>
      _fontApp.copyWith(
        fontSize: 14,
        height: 1.6,
        color: AppColors.white.withValues(alpha: 0.9),
      );

  static TextStyle font14W400Gold(BuildContext context) => _fontApp.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.gold,
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
}
