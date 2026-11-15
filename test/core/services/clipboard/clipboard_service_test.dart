import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/clipboard/clipboard_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const service = ClipboardService();

  test('copies text to the platform clipboard', () async {
    String? copiedText;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        final arguments = call.arguments as Map<Object?, Object?>;
        copiedText = arguments['text'] as String?;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final result = await service.copy('text to copy');

    expect(result, isA<Success<void>>());
    expect(copiedText, 'text to copy');
  });

  test('returns a failure when the platform clipboard fails', () async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => throw PlatformException(code: 'clipboard_error'),
    );
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final result = await service.copy('text to copy');

    expect(result, isA<FailureResult<void>>());
  });
}
