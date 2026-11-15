import 'package:flutter/services.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';

class ClipboardService {
  const ClipboardService();

  Future<Result<void>> copy(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return const Result.success(null);
    } on PlatformException {
      return const Result.failure(
        UnknownFailure(message: 'Clipboard copy failed'),
      );
    }
  }
}
