// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:quran_library/quran_library.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});
  @override
  Widget build(BuildContext context) {
    return QuranLibraryScreen(
      parentContext: context,
      isDark: true,
      backgroundColor: Color(0xFF161a1d),
      textColor: AppColors.textWhite,
      // Selection color: Gold with opacity for readability against black background
      ayahSelectedBackgroundColor: AppColors.gold.withOpacity(0.3),
      // Icon colors: Force Gold to remove default Blue
      ayahIconColor: AppColors.gold,
      // Enable Bookmark Icon (Gold)
      showAyahBookmarkedIcon: true,
      // Customize Top/Bottom text colors to Gold
      topBottomQuranStyle: TopBottomQuranStyle(
        juzTextColor: AppColors.gold,
        hizbTextColor: AppColors.gold,
        sajdaNameColor: AppColors.gold,
        surahNameColor: AppColors.gold,
        pageNumberColor: AppColors.gold,
      ),
    );
  }
}
