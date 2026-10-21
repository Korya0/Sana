import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/app_haptics.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';

class AppClipboard {
  const AppClipboard._();

  static const AppLogger _logger = AppLogger();

  static Future<void> copy({
    required BuildContext context,
    required String text,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      await AppHaptics.light();

      if (!context.mounted) return;
      AppToast.show(
        context,
        AppStrings.copiedToClipboard,
        type: AppToastType.success,
      );
    } on Object catch (error) {
      _logger.error('Copy failed', error: error);

      if (!context.mounted) return;
      AppToast.show(
        context,
        AppStrings.copyError,
        type: AppToastType.error,
      );
    }
  }
}
