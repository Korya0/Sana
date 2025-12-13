import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class WidgetToImage {
  static Future<Uint8List?> capture({
    required BuildContext context,
    required Widget widget,
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    final controller = ScreenshotController();
    try {
      return await controller.captureFromWidget(
        Directionality(textDirection: TextDirection.rtl, child: widget),
        delay: delay,
        context: context,
        pixelRatio: 5,
      );
    } catch (e) {
      debugPrint('Error capturing widget image: $e');
      return null;
    }
  }
}
