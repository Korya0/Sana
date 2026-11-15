import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_constants.dart';

class AppHaptics {
  const AppHaptics._();

  static Future<void> light() => HapticFeedback.lightImpact();

  static Future<void> doubleTap() async {
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(AppConstants.hapticGap200ms);
    await HapticFeedback.mediumImpact();
  }
}
