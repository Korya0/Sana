import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';

class QuranErrorWidget extends StatelessWidget {
  const QuranErrorWidget({required this.onRetry, super.key});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppErrorView(
        onRetry: onRetry,
      ),
    );
  }
}
