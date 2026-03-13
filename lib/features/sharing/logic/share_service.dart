import 'dart:async';
import 'dart:typed_data';

import 'package:sana/core/utils/app_logger.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareService {
  Future<bool> shareImage(
    Uint8List imageBytes, {
    required String imageName,
    String? text,
  });
}

class ShareServiceImpl implements ShareService {
  @override
  Future<bool> shareImage(
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

      // Shared on all platforms uniformly
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text: text,
        ),
      );
      return true;
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error in ShareService.shareImage',
          error: e,
          stackTrace: stack,
        ),
      );
      return false;
    }
  }
}
