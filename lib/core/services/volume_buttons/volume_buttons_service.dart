import 'package:flutter/foundation.dart';

enum VolumeButtonDirection { up, down }

abstract class VolumeButtonsService {
  // Whether this platform can intercept volume buttons.
  bool get isSupported;

  // Starts listening with one active handler.
  void attach(ValueChanged<VolumeButtonDirection> onButton);

  // Stops listening only when the caller still owns the handler.
  void detach(ValueChanged<VolumeButtonDirection> onButton);
}

abstract final class VolumeButtonsPlatform {
  VolumeButtonsPlatform._();

  // Volume buttons are consumed by the native Android bridge only.
  static bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
}
