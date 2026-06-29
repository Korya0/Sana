import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/theme/assets_extension.dart';
import 'package:sana/core/theme/style/theme/color_extension.dart';

extension ContextExtension on BuildContext {
  MyColors get color => Theme.of(this).extension<MyColors>()!;
  MyAssets get image => Theme.of(this).extension<MyAssets>()!;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  MediaQueryData get noScalingMediaQuery =>
      MediaQuery.of(this).copyWith(textScaler: TextScaler.noScaling);

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double responsive(num size) {
    final value = size * (screenWidth / 375);
    final limit1 = size * 0.8;
    final limit2 = size * 1.4;
    return value.clamp(
      limit1 < limit2 ? limit1 : limit2,
      limit1 < limit2 ? limit2 : limit1,
    );
  }
}

extension ColorExtension on Color {
  String toHex() {
    return '#${toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}

extension ResponsiveSize on num {
  double r(BuildContext context) => context.responsive(this);
}
