import 'package:flutter/services.dart';

class AppFeedback {
  AppFeedback._();
  static Future<void> playClickSound() async {
    await SystemSound.play(SystemSoundType.click);
  }

  /// Plays a light haptic feedback (vibration).
  static Future<void> playLightHaptic() async {
    await HapticFeedback.lightImpact();
  }

  /// Plays a medium haptic feedback (vibration).
  static Future<void> playMediumHaptic() async {
    await HapticFeedback.mediumImpact();
  }

  /// Plays a heavy haptic feedback (vibration).
  static Future<void> playHeavyHaptic() async {
    await HapticFeedback.heavyImpact();
  }

  /// Plays the default system vibrate.
  static Future<void> playVibrate() async {
    await HapticFeedback.vibrate();
  }
}
