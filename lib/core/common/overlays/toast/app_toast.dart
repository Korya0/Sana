import 'package:flutter/material.dart';
import 'package:sana/core/common/overlays/toast/app_toast_models.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:toastification/toastification.dart';

export 'app_toast_models.dart';

/// Centralized utility for showing toast notifications across the application.
///
/// Follows SRP by handling only toast display logic and debouncing.
class AppToast {
  static DateTime? _lastToastTime;
  static String? _lastMessage;

  /// Shows a toast notification.
  ///
  /// Uses debouncing to prevent showing identical or rapid-fire toasts.
  static void show(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.top,
    AppToastType type = AppToastType.success,
    int? seconds,
  }) {
    final now = DateTime.now();

    // De-bounce logic: Prevent identical message within 2 seconds
    if (_lastToastTime != null &&
        _lastMessage == message &&
        now.difference(_lastToastTime!) < const Duration(seconds: 2)) {
      return;
    }
    _lastToastTime = now;
    _lastMessage = message;

    toastification.dismissAll();
    final typeData = _getTypeData(type);

    toastification.show(
      context: context,
      type: typeData.type,
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
      borderRadius: BorderRadius.circular(AppSpacing.radiusL),
      primaryColor: typeData.color,
      backgroundColor: AppColors.secondaryBackground,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v20,
        vertical: AppSpacing.v12,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v16,
        vertical: AppSpacing.v32,
      ),
      showProgressBar: false,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      dragToClose: true,
      applyBlurEffect: false,
      boxShadow: [
        BoxShadow(
          color: typeData.color.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      borderSide: BorderSide(color: typeData.color.withValues(alpha: 0.3)),
    );
  }

  static _ToastTypeData _getTypeData(AppToastType type) {
    return switch (type) {
      AppToastType.success => const _ToastTypeData(
        color: AppColors.gold,
        type: ToastificationType.success,
      ),
      AppToastType.error => const _ToastTypeData(
        color: Colors.redAccent,
        type: ToastificationType.error,
      ),
      AppToastType.warning => const _ToastTypeData(
        color: Colors.orangeAccent,
        type: ToastificationType.warning,
      ),
      AppToastType.info => const _ToastTypeData(
        color: Colors.blueAccent,
        type: ToastificationType.info,
      ),
    };
  }
}

class _ToastTypeData {
  const _ToastTypeData({
    required this.color,
    required this.type,
  });
  final Color color;
  final ToastificationType type;
}
