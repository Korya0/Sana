import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart' as ql;
import 'package:sana/core/utils/context_extension.dart';

class QuranSuccessWidget extends StatelessWidget {
  const QuranSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ql.QuranLibraryScreen(
      parentContext: context,
      isDark: isDark,

      backgroundColor: isDark
          ? context.color.secondaryScaffoldBackgroundColor
          : context.color.scaffoldBackgroundColor,
      textColor: context.color.textPrimary,
      ayahSelectedBackgroundColor: context.color.primary,

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
