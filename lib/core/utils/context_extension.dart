import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
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

extension ResponsiveSize on num {
  double r(BuildContext context) => context.responsive(this);
}
