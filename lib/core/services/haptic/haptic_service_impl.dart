import 'package:flutter/services.dart';
import 'package:sana/core/services/haptic/haptic_service.dart';

class HapticServiceImpl implements HapticService {
  const HapticServiceImpl();

  @override
  Future<void> playVibrate() async {
    await HapticFeedback.vibrate();
  }

  @override
  Future<void> playDoubleVibrate() async {
    await HapticFeedback.vibrate();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.vibrate();
  }
}
