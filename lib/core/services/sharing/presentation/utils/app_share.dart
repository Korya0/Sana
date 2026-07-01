import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/core/utils/app_logger.dart';

class AppShare {
  const AppShare._();

  static Future<void> shareWidgetAsImage({
    required BuildContext context,
    required Widget widget,
    required String imageName,
    String? text,
  }) async {
    try {
      final success = await WidgetToImageHelper.shareWidget(
        context: context,
        widget: widget,
        imageName: imageName,
        text: text,
      );

      if (!success && context.mounted) {
        AppToast.show(
          context,
          AppStrings.sharingError,
          type: AppToastType.error,
        );
      }
    } on Exception catch (e) {
      unawaited(AppLogger.localError('Share Error', error: e));
      if (context.mounted) {
        AppToast.show(
          context,
          AppStrings.sharingError,
          type: AppToastType.error,
        );
      }
    }
  }
}
