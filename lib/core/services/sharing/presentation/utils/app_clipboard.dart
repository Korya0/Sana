import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/app_logger.dart';

class AppClipboard {
  const AppClipboard._();

  static Future<void> copy({
    required BuildContext context,
    required String text,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text.trim()));
      if (context.mounted) {
        AppToast.show(context, AppStrings.copiedToClipboard);
      }
    } on Exception catch (e) {
      unawaited(AppLogger.localError('Copy Error', error: e));
      if (context.mounted) {
        AppToast.show(
          context,
          AppStrings.copyError,
          type: AppToastType.error,
        );
      }
    }
  }
}
