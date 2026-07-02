import 'package:flutter/services.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';

class HapticServiceImpl implements IHapticService {
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
