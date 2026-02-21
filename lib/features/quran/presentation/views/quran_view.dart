import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:quran_library/quran_library.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QuranView extends StatelessWidget {
  const QuranView({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeAppPostFrame(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF161a1d),
            body: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          );
        }
        return QuranLibraryScreen(
          parentContext: context,
          isDark: true,
          backgroundColor: const Color(0xFF161a1d),
          textColor: AppColors.textWhite,
          // Selection color: Gold with opacity for readability against black background
          ayahSelectedBackgroundColor: AppColors.gold.withValues(alpha: 0.3),
          // Icon colors: Force Gold to remove default Blue
          ayahIconColor: AppColors.gold,
          // Customize Top/Bottom text colors to Gold
          topBottomQuranStyle: const TopBottomQuranStyle(
            juzTextColor: AppColors.gold,
            hizbTextColor: AppColors.gold,
            sajdaNameColor: AppColors.gold,
            surahNameColor: AppColors.gold,
            pageNumberColor: AppColors.gold,
          ),
        );
      },
    );
  }
}
