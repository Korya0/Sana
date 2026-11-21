import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:toastification/toastification.dart';

enum AppToastType { info, success, error }

class AppToast {
  const AppToast._();

  static DateTime? _lastToastTime;
  static String? _lastMessage;
  static ToastificationItem? _activeToast;

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

    // Remove the previous toast instantly — no exit-animation window
    final previous = _activeToast;
    _activeToast = null;
    if (previous != null) {
      toastification.dismiss(previous, showRemoveAnimation: false);
    }

    _activeToast = toastification.showCustom(
      context: context,
      alignment: Alignment.topCenter,
      autoCloseDuration: AppConstants.toastDuration2s,
      builder: (context, item) => _ToastContent(message: message, type: type),
    );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({required this.message, required this.type});

  final String message;
  final AppToastType type;

  @override
  Widget build(BuildContext context) {
    final accent = switch (type) {
      AppToastType.success => AppColorsCommon.successColor,
      AppToastType.error => context.color.errorText,
      AppToastType.info => context.color.primary,
    };
    final icon = switch (type) {
      AppToastType.success => AppIcons.checkCircle,
      AppToastType.error => AppIcons.error,
      AppToastType.info => AppIcons.info,
    };

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p32,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p20,
        vertical: AppSize.p12,
      ),
      decoration: BoxDecoration(
        color: context.color.secondaryScaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSize.r16),
        border: Border.all(
          color: accent.withValues(alpha: AppConstants.opacitySoft),
          width: AppSize.borderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSize.icon24, color: accent),
          AppGap.w(AppSize.p8),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
              maxLines: AppConstants.maxTwoLines,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14W700Primary(context),
            ),
          ),
        ],
      ),
    );
  }
}
