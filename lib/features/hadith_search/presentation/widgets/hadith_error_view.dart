import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';

class HadithErrorView extends StatelessWidget {
  const HadithErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: AppErrorWidget(
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}
