import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/sharing/logic/share_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:screenshot/screenshot.dart';

class WidgetToImage {
  const WidgetToImage._();

  /// Captures a widget and returns its bytes.
  /// Used internally and can be used for custom logic.
  static Future<Uint8List?> capture({
    required BuildContext context,
    required Widget widget,
    Duration delay = const Duration(milliseconds: 100),
    double pixelRatio = 3, // Golden ratio for HD quality without bloating size
  }) async {
    final controller = ScreenshotController();
    try {
      return await controller.captureFromWidget(
        Directionality(textDirection: TextDirection.rtl, child: widget),
        delay: delay,
        context: context,
        pixelRatio: pixelRatio,
      );
    } catch (e, stack) {
      await AppLogger.error(
        'Capture widget failed',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Captures a widget then shares it using the central ShareService.
  static Future<void> shareWidget({
    required BuildContext context,
    required Widget widget,
    required String imageName,
    String? text,
  }) async {
    final bytes = await capture(context: context, widget: widget);
    if (bytes != null) {
      await sl<ShareService>().shareImage(
        bytes,
        imageName: imageName,
        text: text,
      );
    }
  }
}
