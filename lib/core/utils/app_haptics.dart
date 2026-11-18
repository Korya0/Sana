import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_constants.dart';

class AppHaptics {
  const AppHaptics._();

  static Future<void> light() => HapticFeedback.mediumImpact();

  static Future<void> doubleTap() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(AppConstants.hapticGap200ms);
    await HapticFeedback.heavyImpact();
  }
}
