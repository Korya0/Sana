import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';

class AzkarDestructiveAction {
  const AzkarDestructiveAction._();

  static Future<bool> run(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required Future<Result<void>> Function() action,
    String? successMessage,
  }) async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: AppStrings.cancel,
    );
    if (confirmed != true || !context.mounted) return false;

    final result = await action();
    if (!context.mounted) return false;

    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
      return false;
    }

    if (successMessage != null) {
      AppToast.show(context, successMessage, type: AppToastType.success);
    }
    return true;
  }
}
