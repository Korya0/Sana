import 'package:flutter/services.dart';

Future<void> playVibrate() async {
  await HapticFeedback.vibrate();
}

Future<void> playDoubleVibrate() async {
  await HapticFeedback.vibrate();
  await Future<void>.delayed(const Duration(milliseconds: 100));
  await HapticFeedback.vibrate();
}
