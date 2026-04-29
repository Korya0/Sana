import 'package:flutter/services.dart';

class AppFeedback {
  AppFeedback._();

  static Future<void> playVibrate() async {
    await HapticFeedback.vibrate();
  }

  static Future<void> playDoubleVibrate() async {
    await HapticFeedback.vibrate();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.vibrate();
  }
}
