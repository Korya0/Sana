import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
class QuranErrorWidget extends StatelessWidget {
  const QuranErrorWidget({
    required this.onRetry,
    required this.message,
    super.key,
  });
  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondaryScaffoldBackgroundColor,
      body: AppErrorView(
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}
