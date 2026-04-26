import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  MediaQueryData get noScalingMediaQuery =>
      MediaQuery.of(this).copyWith(textScaler: TextScaler.noScaling);
}
