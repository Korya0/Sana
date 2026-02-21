import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';

Future<void> showHadithDialog(
  BuildContext context,
  DailyContentState state,
) async {
  if (state.dailyHadith == null) return;

  final cubit = context.read<DailyContentCubit>();

  // Mark hadith as viewed
  await cubit.markHadithAsViewed();

  if (!context.mounted) return;

  unawaited(
    showDialog<void>(
      context: context,
      builder: (context) => DailyContentDialog(
        title: state.dailyHadith!.header,
        subTitle: state.dailyHadith!.content,
        source: state.dailyHadith!.attribution,
        initialIsFavorite: state.isHadithFavorite,
        onFavoriteToggle: cubit.toggleHadithFavorite,
      ),
    ),
  );
}

Future<void> showSunnahDialog(
  BuildContext context,
  DailyContentState state,
) async {
  if (state.dailySunnah == null) return;

  final cubit = context.read<DailyContentCubit>();

  // Mark sunnah as viewed
  await cubit.markSunnahAsViewed();

  if (!context.mounted) return;

  unawaited(
    showDialog<void>(
      context: context,
      builder: (context) => DailyContentDialog(
        title: state.dailySunnah!.header,
        subTitle: state.dailySunnah!.content,
        source: state.dailySunnah?.attribution,
        initialIsFavorite: state.isSunnahFavorite,
        onFavoriteToggle: cubit.toggleSunnahFavorite,
      ),
    ),
  );
}
