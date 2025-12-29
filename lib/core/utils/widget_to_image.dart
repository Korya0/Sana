// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class WidgetToImage {
  static Future<Uint8List?> capture({
    required BuildContext context,
    required Widget widget,
    Duration delay = const Duration(milliseconds: 100),
  }) async {
    final controller = ScreenshotController();
    try {
      return await controller.captureFromWidget(
        Directionality(textDirection: TextDirection.rtl, child: widget),
        delay: delay,
        context: context,
        pixelRatio: 4.0,
      );
    } catch (e) {
      debugPrint('Error capturing widget image: $e');
      return null;
    }
  }

  static Future<void> shareWidget({
    required BuildContext context,
    required Widget widget,
    required String imageName,
  }) async {
    try {
      final Uint8List? imageBytes = await capture(
        context: context,
        widget: widget,
      );

      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File(
          '${directory.path}/$imageName.png',
        ).create();
        await imagePath.writeAsBytes(imageBytes);

        await Share.shareXFiles([XFile(imagePath.path)]);
      }
    } catch (e) {
      debugPrint('Error sharing widget image: $e');
    }
  }
}
