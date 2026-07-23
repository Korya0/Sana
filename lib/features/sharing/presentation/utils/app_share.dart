import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/sharing/logic/i_share_service.dart';
import 'package:sana/features/sharing/presentation/utils/widget_to_image_helper.dart';
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
      final helper = sl<WidgetToImageHelper>();
      final shareService = sl<IShareService>();
      const delay = kIsWeb
          ? AppConstants.animationSlower500ms
          : Duration(milliseconds: 100);

      final captureResult = await helper.capture(
        context: context,
        widget: widget,
        delay: delay,
      );

      switch (captureResult) {
        case Success(data: final bytes):
          final shareResult = await shareService.shareImage(
            bytes,
            imageName: imageName,
            text: text,
          );
          switch (shareResult) {
            case Success(data: final success):
              if (!success && context.mounted) {
                AppToast.show(
                  context,
                  AppStrings.sharingError,
                  type: AppToastType.error,
                );
              }
            case FailureResult(:final failure):
              if (context.mounted) {
                AppToast.show(
                  context,
                  failure.message,
                  type: AppToastType.error,
                );
              }
          }
        case FailureResult(:final failure):
          if (context.mounted) {
            AppToast.show(
              context,
              failure.message,
              type: AppToastType.error,
            );
          }
      }
    } on Object catch (e) {
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
