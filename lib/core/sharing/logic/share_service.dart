import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareService {
  Future<void> shareImage(
    Uint8List imageBytes, {
    required String imageName,
    String? text,
  });
}

class ShareServiceImpl implements ShareService {
  @override
  Future<void> shareImage(
    Uint8List imageBytes, {
    required String imageName,
    String? text,
  }) async {
    try {
      final xFile = XFile.fromData(
        imageBytes,
        mimeType: 'image/png',
        name: '$imageName.png',
      );

      if (kIsWeb) {
        // [Web Support] مشاركة مباشرة عبر XFile.fromData
        await SharePlus.instance.share(
          ShareParams(
            files: [xFile],
            text: text,
          ),
        );
        return;
      }

      // [Mobile Support] حفظ مؤقت للمشاركة
      final tempDir = await getTemporaryDirectory();
      final file = io.File('${tempDir.path}/$imageName.png');
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: text,
        ),
      );
    } catch (e, stack) {
      await AppLogger.error(
        'Error in ShareService.shareImage',
        error: e,
        stackTrace: stack,
      );
    }
  }
}
