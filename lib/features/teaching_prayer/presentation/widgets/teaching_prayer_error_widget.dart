import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';

class TeachingPrayerErrorWidget extends StatelessWidget {
  const TeachingPrayerErrorWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      message: message,
      onRetry: onRetry,
    );
  }
}
