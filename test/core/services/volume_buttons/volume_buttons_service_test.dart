import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service_impl.dart';
import 'package:sana/core/utils/app_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('sana/volume_buttons');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('reports Android as supported and iOS as unsupported', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(VolumeButtonsPlatform.isSupported, isTrue);
    expect(
      DefaultVolumeButtonsService(const _SilentLogger()).isSupported,
      isTrue,
    );

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(VolumeButtonsPlatform.isSupported, isFalse);
    expect(
      DefaultVolumeButtonsService(const _SilentLogger()).isSupported,
      isFalse,
    );
  });

  test('attach enables the native channel', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final service = DefaultVolumeButtonsService(const _SilentLogger());

    service.attach((_) {});

    expect(calls, hasLength(1));
    expect(calls.single.method, 'setEnabled');
    expect(calls.single.arguments, isTrue);
  });

  test('detach by the current owner disables the native channel', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final service = DefaultVolumeButtonsService(const _SilentLogger());
    void handler(VolumeButtonDirection direction) {}

    service.attach(handler);
    service.detach(handler);

    expect(calls.map((call) => call.arguments), [true, false]);
  });

  test('detach by a previous owner leaves the current owner enabled', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final service = DefaultVolumeButtonsService(const _SilentLogger());
    void first(VolumeButtonDirection direction) {}
    void second(VolumeButtonDirection direction) {}

    service.attach(first);
    service.attach(second);
    service.detach(first);

    expect(calls.map((call) => call.arguments), [true, true]);

    service.detach(second);
    expect(calls.map((call) => call.arguments), [true, true, false]);
  });

  test(
    'forwards native volume button events to the attached handler',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final service = DefaultVolumeButtonsService(const _SilentLogger());
      final received = <VolumeButtonDirection>[];
      service.attach(received.add);

      await _sendNativeEvent('up');
      await _sendNativeEvent('down');

      expect(received, [VolumeButtonDirection.up, VolumeButtonDirection.down]);
    },
  );

  test('does not attach on unsupported platforms', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final service = DefaultVolumeButtonsService(const _SilentLogger());
    final received = <VolumeButtonDirection>[];

    service.attach(received.add);
    await _sendNativeEvent('up');

    expect(calls, isEmpty);
    expect(received, isEmpty);
  });

  test('a missing native implementation does not crash attach', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          throw MissingPluginException();
        });
    final service = DefaultVolumeButtonsService(const _SilentLogger());

    service.attach((_) {});
    await Future<void>.delayed(Duration.zero);
  });
}

Future<void> _sendNativeEvent(String direction) =>
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          'sana/volume_buttons',
          const StandardMethodCodec().encodeMethodCall(
            MethodCall('onVolumeButton', direction),
          ),
          (_) {},
        );

class _SilentLogger extends AppLogger {
  const _SilentLogger();

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}
