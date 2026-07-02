import 'dart:async';
import 'dart:typed_data';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/sharing/logic/i_share_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class SharePlusWrapper {
  Future<void> share(ShareParams params) async {
    await SharePlus.instance.share(params);
  }
}

class ShareServiceImpl implements IShareService {
  const ShareServiceImpl(this._sharePlusWrapper);

  final SharePlusWrapper _sharePlusWrapper;

  @override
  Future<Result<bool>> shareImage(
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

      await _sharePlusWrapper.share(
        ShareParams(
          files: [xFile],
          text: text,
        ),
      );
      return const Result.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Error in ShareService.shareImage',
          error: e,
          stackTrace: stack,
        ),
      );

      final message = e.toString().toLowerCase();
      if (message.contains('permission') || message.contains('denied')) {
        return const Result.failure(
          UnknownFailure(message: 'تم رفض إذن مشاركة الملفات'),
        );
      }
      
      return Result.failure(
        UnknownFailure(message: '${AppStrings.sharingError}: $e'),
      );
    }
  }
}
