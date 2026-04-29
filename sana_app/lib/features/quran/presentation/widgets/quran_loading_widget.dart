import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

/// Uses CircularProgressIndicator instead of Skeletonizer — library init has no skeleton-able UI.
class QuranLoadingWidget extends StatelessWidget {
  const QuranLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.secondaryBackground,

      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
