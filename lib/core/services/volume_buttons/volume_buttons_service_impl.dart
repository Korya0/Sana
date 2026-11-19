import 'package:flutter/services.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/core/utils/app_logger.dart';

class DefaultVolumeButtonsService implements VolumeButtonsService {
  // Creates service and registers the native callback.
  DefaultVolumeButtonsService(this._logger) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static const String _channelName = 'sana/volume_buttons';

  final AppLogger _logger;
  final MethodChannel _channel = const MethodChannel(_channelName);

  ValueChanged<VolumeButtonDirection>? _onButton;

  @override
  bool get isSupported => VolumeButtonsPlatform.isSupported;

  @override
  void attach(ValueChanged<VolumeButtonDirection> onButton) {
    if (!isSupported) return;

    _onButton = onButton;
    _setEnabled(true);
  }

  @override
  void detach(ValueChanged<VolumeButtonDirection> onButton) {
    if (!identical(_onButton, onButton)) return;

    _onButton = null;
    if (!isSupported) return;

    _setEnabled(false);
  }

  // Sends the native enable flag without blocking the caller.
  Future<void> _setEnabled(bool enabled) async {
    try {
      await _channel.invokeMethod<void>('setEnabled', enabled);
    } on MissingPluginException {
      // Expected on platforms without the native bridge.
    } on PlatformException catch (error, stackTrace) {
      _logger.error(
        'VolumeButtons: setEnabled failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // Handles native -> Dart volume button events.
  Future<Object?> _handleMethodCall(MethodCall call) async {
    if (call.method != 'onVolumeButton') return null;

    final direction = switch (call.arguments) {
      'up' => VolumeButtonDirection.up,
      'down' => VolumeButtonDirection.down,
      _ => null,
    };
    if (direction != null) _onButton?.call(direction);
    return null;
  }
}
