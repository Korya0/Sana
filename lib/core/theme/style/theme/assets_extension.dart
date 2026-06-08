import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_assets.dart';

class MyAssets extends ThemeExtension<MyAssets> {
  const MyAssets({
    required this.appLogo,
    required this.mapUrlTemplate,
  });

  final String appLogo;
  final String mapUrlTemplate;

  @override
  ThemeExtension<MyAssets> copyWith({
    String? appLogo,
    String? mapUrlTemplate,
  }) {
    return MyAssets(
      appLogo: appLogo ?? this.appLogo,
      mapUrlTemplate: mapUrlTemplate ?? this.mapUrlTemplate,
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
      mapUrlTemplate: other.mapUrlTemplate,
    );
  }

  static const MyAssets dark = MyAssets(
    appLogo: AppAssets.logo,
    mapUrlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
  );

  static const MyAssets light = MyAssets(
    appLogo: AppAssets.logo,
    mapUrlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
  );
}
