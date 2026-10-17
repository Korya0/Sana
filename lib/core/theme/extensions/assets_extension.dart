import 'package:flutter/material.dart';

class MyAssets extends ThemeExtension<MyAssets> {
  const MyAssets();

  @override
  ThemeExtension<MyAssets> copyWith() => const MyAssets();

  @override
  ThemeExtension<MyAssets> lerp(
    covariant ThemeExtension<MyAssets>? other,
    double t,
  ) => this;

  static const MyAssets light = MyAssets();

  static const MyAssets dark = MyAssets();
}
