import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:quran_library/quran_library.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = initializeAppPostFrame();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
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
