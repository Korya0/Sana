import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QuranLoadingWidget extends StatelessWidget {
  const QuranLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
