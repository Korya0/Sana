import 'package:flutter/material.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';

void showHadithDialog(BuildContext context, DailyContentState state) {
  if (state.dailyHadith == null) return;
  showDialog(
    context: context,
    builder: (context) => DailyContentDialog(
      subTitle: state.dailyHadith!.text,
      source: state.dailyHadith!.subText,
    ),
  );
}

void showSunnahDialog(BuildContext context, DailyContentState state) {
  if (state.dailySunnah == null) return;
  showDialog(
    context: context,
    builder: (context) => DailyContentDialog(
      title: state.dailySunnah!.title,
      subTitle: state.dailySunnah!.subText,
      source: state.dailySunnah?.source,
    ),
  );
}
