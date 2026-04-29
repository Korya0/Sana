import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart' as ql;
import 'package:sana/core/theme/style/app_colors.dart';

class QuranSuccessWidget extends StatelessWidget {
  const QuranSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ql.QuranLibraryScreen(
      parentContext: context,
      isDark: true,

      backgroundColor: AppColors.secondaryBackground,
      textColor: AppColors.textWhite,
      ayahSelectedBackgroundColor: AppColors.primary.withValues(
        alpha: 0.3,
      ),

      indexTabStyle: const ql.IndexTabStyle(
        surahNumberDecorationColor: AppColors.primary,
      ),
      ayahIconColor: AppColors.primary,
      topBottomQuranStyle: const ql.TopBottomQuranStyle(
        juzTextColor: AppColors.primary,
        hizbTextColor: AppColors.primary,
        sajdaNameColor: AppColors.primary,
        surahNameColor: AppColors.primary,
        pageNumberColor: AppColors.primary,
      ),
    );
  }
}
