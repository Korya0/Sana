import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/sharing/logic/share_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:screenshot/screenshot.dart';

class WidgetToImageHelper {
  const WidgetToImageHelper._();

  static Future<Uint8List?> capture({
    required BuildContext context,
    required Widget widget,
    Duration delay = kIsWeb
        ? const Duration(
            milliseconds: 500,
          )
        : const Duration(milliseconds: 100),
    double pixelRatio = 3,
  }) async {
    final controller = ScreenshotController();

    try {
      return await controller.captureFromWidget(
        Directionality(
          textDirection: Directionality.of(context),
          child: widget,
        ),
        delay: delay,
        context: context,
        pixelRatio: pixelRatio,
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Capture widget failed',
          error: e,
          stackTrace: stack,
        ),
      );
      return null;
    }
  }

  static Future<bool> shareWidget({
    required BuildContext context,
    required Widget widget,
    required String imageName,
    String? text,
  }) async {
    final bytes = await capture(context: context, widget: widget);
    if (bytes != null) {
      final result = await sl<ShareService>().shareImage(
        bytes,
        imageName: imageName,
        text: text,
      );
      
      return result.when(
        success: (data) => data,
        failure: (_) => false,
      );
    }
    return false;
  }
}
