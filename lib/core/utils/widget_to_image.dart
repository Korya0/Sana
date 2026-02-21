import 'dart:io' as io;
import 'package:flutter/foundation.dart';
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
        pixelRatio: 4,
      );
    } on Exception catch (e) {
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
      final imageBytes = await capture(
        context: context,
        widget: widget,
      );

      if (imageBytes != null) {
        if (kIsWeb) {
          // [Web Support] مشاركة الصور في الويب بدون الحاجة لحفظها كملف
          await SharePlus.instance.share(
            ShareParams(
              files: [
                XFile.fromData(
                  imageBytes,
                  mimeType: 'image/png',
                  name: '$imageName.png',
                ),
              ],
            ),
          );
          return;
        }

        final directory = await getTemporaryDirectory();
        final imagePath = await io.File(
          '${directory.path}/$imageName.png',
        ).create();
        await imagePath.writeAsBytes(imageBytes);

        await SharePlus.instance.share(
          ShareParams(files: [XFile(imagePath.path)]),
        );
      }
    } on Exception catch (e) {
      debugPrint('Error sharing widget image: $e');
    }
  }
}
