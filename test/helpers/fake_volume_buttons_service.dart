import 'package:flutter/foundation.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';

class FakeVolumeButtonsService implements VolumeButtonsService {
  FakeVolumeButtonsService({this.isSupported = true});

  @override
  final bool isSupported;

  ValueChanged<VolumeButtonDirection>? handler;
  int attachCalls = 0;
  int detachCalls = 0;

  @override
  void attach(ValueChanged<VolumeButtonDirection> onButton) {
    handler = onButton;
    attachCalls++;
  }

  @override
  void detach(ValueChanged<VolumeButtonDirection> onButton) {
    if (identical(handler, onButton)) handler = null;
    detachCalls++;
  }

  void emit(VolumeButtonDirection direction) => handler?.call(direction);
}
