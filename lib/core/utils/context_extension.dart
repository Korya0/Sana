import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  MediaQueryData get noScalingMediaQuery =>
      MediaQuery.of(this).copyWith(textScaler: TextScaler.noScaling);

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double responsive(num size) =>
      (size * (screenWidth / 375)).clamp(size * 0.8, size * 1.4);
}

extension ResponsiveSize on num {
  double r(BuildContext context) => context.responsive(this);
}
