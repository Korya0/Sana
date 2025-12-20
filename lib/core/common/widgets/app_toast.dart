// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:toastification/toastification.dart';

enum ToastPosition { top, bottom }

class AppToast {
  static DateTime? _lastToastTime;

  static void show(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.top,
    int? seconds,
  }) {
    final now = DateTime.now();
    if (_lastToastTime != null &&
        now.difference(_lastToastTime!) < Duration(seconds: seconds ?? 2)) {
      return;
    }
    _lastToastTime = now;

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(
        message,
        style: AppTextStyles.font14W600White(context),
        textAlign: TextAlign.center,
      ),
      alignment: position == ToastPosition.top
          ? Alignment.topCenter
          : Alignment.bottomCenter,
      autoCloseDuration: Duration(seconds: seconds ?? 2),
      borderRadius: BorderRadius.circular(16),
      primaryColor: AppColors.gold,
      backgroundColor: AppColors.secondaryBackground,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      dragToClose: true,
      applyBlurEffect: false,
      boxShadow: [
        BoxShadow(
          color: AppColors.gold.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
    );
  }
}
