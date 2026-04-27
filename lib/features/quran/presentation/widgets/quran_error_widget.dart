import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QuranErrorWidget extends StatelessWidget {
  const QuranErrorWidget({required this.onRetry, super.key});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBackground,

      body: AppErrorView(
        onRetry: onRetry,
      ),
    );
  }
}
