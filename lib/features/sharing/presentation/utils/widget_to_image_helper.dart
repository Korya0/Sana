import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:screenshot/screenshot.dart';

class WidgetToImageHelper {
  const WidgetToImageHelper({required this.screenshotController});

  final ScreenshotController screenshotController;

  Future<Result<Uint8List>> capture({
    required BuildContext context,
    required Widget widget,
    required Duration delay,
    double pixelRatio = 3,
  }) async {
    try {
      final bytes = await screenshotController.captureFromWidget(
        Theme(
          data: AppTheme.darkTheme,
          child: Directionality(
            textDirection: Directionality.of(context),
            child: widget,
          ),
        ),
        delay: delay,
        context: context,
        pixelRatio: pixelRatio,
      );

      return Result.success(bytes);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Capture widget failed',
          error: e,
          stackTrace: stack,
        ),
      );
      return Result.failure(
        UnknownFailure(message: e.toString()),
      );
    }
  }
}
