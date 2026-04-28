import 'dart:async';
import 'dart:typed_data';

import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareService {
  Future<ApiResult<bool>> shareImage(
    Uint8List imageBytes, {
    required String imageName,
    String? text,
  });
}

class ShareServiceImpl implements ShareService {
  @override
  Future<ApiResult<bool>> shareImage(
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

      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text: text,
        ),
      );
      return const ApiResult.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error in ShareService.shareImage',
          error: e,
          stackTrace: stack,
        ),
      );
      return ApiResult.failure(
        Failure.unknown(message: e.toString()),
      );
    }
  }
}
