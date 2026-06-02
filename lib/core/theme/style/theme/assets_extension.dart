import 'package:flutter/material.dart';
import 'package:sana/core/constants/generated/assets.gen.dart';

class MyAssets extends ThemeExtension<MyAssets> {
  const MyAssets({
    required this.appLogo,
  });

  final AssetGenImage? appLogo;

  @override
  ThemeExtension<MyAssets> copyWith({
    AssetGenImage? appLogo,
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

  static final MyAssets dark = MyAssets(
    appLogo: Assets.images.appLogoDark,
  );

  static final MyAssets light = MyAssets(
    appLogo: Assets.images.appLogoLight,
  );
}
