import 'package:flutter/services.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';

class ClipboardService {
  const ClipboardService();

  // Copies text to clipboard
  Future<Result<void>> copy(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      const AppLogger().error(
        'Clipboard copy failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        UnknownFailure(message: 'Clipboard copy failed'),
      );
    }
  }
}
