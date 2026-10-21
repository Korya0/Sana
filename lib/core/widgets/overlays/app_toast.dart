import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:toastification/toastification.dart';

enum AppToastType { info, success, error }

class AppToast {
  const AppToast._();

  static DateTime? _lastToastTime;
  static String? _lastMessage;

  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
  }) {
    final now = DateTime.now();

    // Debounce identical toasts
    if (_lastToastTime != null &&
        _lastMessage == message &&
        now.difference(_lastToastTime!) < AppConstants.toastDuration2s) {
      return;
    }
    _lastToastTime = now;
    _lastMessage = message;

    toastification.dismissAll();
    final typeData = _getTypeData(context, type);

    toastification.show(
      context: context,
      type: typeData.type,
      style: ToastificationStyle.minimal,
      title: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.font14W700Primary(context),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: AppConstants.toastDuration2s,
      borderRadius: BorderRadius.circular(AppSize.r16),
      primaryColor: typeData.color,
      backgroundColor: context.color.secondaryScaffoldBackgroundColor,
      foregroundColor: context.color.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p20,
        vertical: AppSize.p12,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p32,
      ),
      showProgressBar: false,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      dragToClose: true,
      applyBlurEffect: false,
      boxShadow: [
        BoxShadow(
          color: typeData.color.withValues(
            alpha: AppConstants.opacitySubtle,
          ),
          blurRadius: AppSize.p12,
          offset: Offset(0, AppSize.p4),
        ),
      ],
      borderSide: BorderSide(
        color: typeData.color.withValues(
          alpha: AppConstants.opacitySoft,
        ),
      ),
    );
  }

  static _ToastTypeData _getTypeData(
    BuildContext context,
    AppToastType type,
  ) => switch (type) {
    AppToastType.success => _ToastTypeData(
      color: context.color.secondary,
      type: ToastificationType.success,
    ),
    AppToastType.error => const _ToastTypeData(
      color: AppColorsCommon.errorColor,
      type: ToastificationType.error,
    ),
    AppToastType.info => _ToastTypeData(
      color: context.color.primary,
      type: ToastificationType.info,
    ),
  };
}

class _ToastTypeData {
  const _ToastTypeData({required this.color, required this.type});

  final Color color;
  final ToastificationType type;
}
