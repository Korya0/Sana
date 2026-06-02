import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:quran_library/quran.dart' as ql;
class QuranSuccessWidget extends StatelessWidget {
  const QuranSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ql.QuranLibraryScreen(
      parentContext: context,
      isDark: true,

      backgroundColor: context.color.secondaryScaffoldBackgroundColor,
      textColor: context.color.textPrimary,
      ayahSelectedBackgroundColor: context.color.primary.withValues(
        alpha: 0.3,
      ),

      indexTabStyle: ql.IndexTabStyle(
        surahNumberDecorationColor: context.color.primary,
      ),
      ayahIconColor: context.color.primary,
      topBottomQuranStyle: ql.TopBottomQuranStyle(
        juzTextColor: context.color.primary,
        hizbTextColor: context.color.primary,
        sajdaNameColor: context.color.primary,
        surahNameColor: context.color.primary,
        pageNumberColor: context.color.primary,
      ),
    );
  }
}

