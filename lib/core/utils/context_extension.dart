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
}

extension ColorExtension on Color {
  String toHex() {
    return '#${toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
