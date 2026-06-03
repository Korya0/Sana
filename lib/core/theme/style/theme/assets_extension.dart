import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_assets.dart';

class MyAssets extends ThemeExtension<MyAssets> {
  const MyAssets({
    required this.appLogo,
  });

  final String appLogo;

  @override
  ThemeExtension<MyAssets> copyWith({
    String? appLogo,
  }) {
    return MyAssets(
      appLogo: appLogo ?? this.appLogo,
    );
  }

  @override
  ThemeExtension<MyAssets> lerp(
    covariant ThemeExtension<MyAssets>? other,
    double t,
  ) {
    if (other is! MyAssets) {
      return this;
    }
    return MyAssets(
      appLogo: other.appLogo,
    );
  }

  static const MyAssets dark = MyAssets(
    appLogo: AppAssets.appLogoDark,
  );

  static const MyAssets light = MyAssets(
    appLogo: AppAssets.appLogoLight,
  );
}
