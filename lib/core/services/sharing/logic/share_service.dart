import 'dart:async';
import 'dart:typed_data';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/sharing/logic/i_share_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class ShareServiceImpl implements IShareService {
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
      return const ApiResult.failure(
        UnknownFailure(message: AppStrings.sharingError),
      );
    }
  }
}
