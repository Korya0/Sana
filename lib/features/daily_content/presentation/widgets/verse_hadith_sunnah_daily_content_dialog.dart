import 'package:flutter/material.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';

void showVerseDialog(BuildContext context, DailyContentState state) {
  if (state.dailyVerse == null) return;

  showDialog(
    context: context,
    builder: (context) => DailyContentDialog(
      mainContent: state.dailyVerse!.text,
      subContent: "سورة ${state.dailyVerse!.surahName}",
      title: 'آية للتذكير',
    ),
  );
}

void showHadithDialog(BuildContext context, DailyContentState state) {
  if (state.dailyHadith == null) return;
  showDialog(
    context: context,
    builder: (context) => DailyContentDialog(
      title: "حديث اليوم",
      mainContent: state.dailyHadith!.text,
      subContent: state.dailyHadith!.narrator,
    ),
  );
}

void showSunnahDialog(BuildContext context, DailyContentState state) {
  if (state.dailySunnah == null) return;
  showDialog(
    context: context,
    builder: (context) => DailyContentDialog(
      title: "سنة مهجورة",
      mainContent: state.dailySunnah!.text,
      subContent: state.dailySunnah!.description,
    ),
  );
}
