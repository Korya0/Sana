import 'package:flutter/widgets.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/clipboard/clipboard_service.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';

// Copies with error feedback
Future<bool> copyText(
  BuildContext context,
  String text, {
  required String errorMessage,
  ClipboardService service = const ClipboardService(),
}) async {
  final result = await service.copy(text);
  final succeeded = result is Success<void>;

  if (!succeeded && context.mounted) {
    AppToast.show(context, errorMessage, type: AppToastType.error);
  }

  return succeeded;
}
