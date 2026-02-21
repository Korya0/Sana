import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareService {
  Future<void> shareImage(Uint8List imageBytes, {String? text});
}

class ShareServiceImpl implements ShareService {
  @override
  Future<void> shareImage(Uint8List imageBytes, {String? text}) async {
    try {
      if (kIsWeb) {
        // [Web Support] استخدام XFile.fromData للمشاركة في الويب لتجنب استخدام نظام الملفات
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                imageBytes,
                mimeType: 'image/png',
                name: 'zikr.png',
              ),
            ],
            text: text,
          ),
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = io.File(
        '${tempDir.path}/share_zikr_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: text),
      );
    } on Exception catch (e) {
      debugPrint('Error sharing image: $e');
    }
  }
}
