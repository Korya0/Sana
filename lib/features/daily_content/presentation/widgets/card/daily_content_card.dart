import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_share.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentCard extends StatelessWidget {
  const DailyContentCard({required this.type, super.key});
  final DailyContentType type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final isHadith = type == DailyContentType.hadith;
        final item = isHadith ? state.dailyHadith : state.dailySunnah;
        if (item == null) return const SizedBox.shrink();

        final isFav = isHadith
            ? state.isHadithFavorite
            : state.isSunnahFavorite;

        return DailyContentBaseCard(
          title: isHadith ? AppStrings.hadithOfTheDay : AppStrings.sunnah,
          content: item.content,
          source: item.attribution,
          explanation: item.explanation,
          icon: FlutterIslamicIcons.mohammad,
          isFavorite: isFav,
          onFavoriteToggle: () {
            if (isHadith) {
              unawaited(
                context.read<DailyContentCubit>().toggleHadithFavorite(),
              );
            } else {
              unawaited(
                context.read<DailyContentCubit>().toggleSunnahFavorite(),
              );
            }
          },
          onTap: () {
            if (isHadith) {
              unawaited(context.read<DailyContentCubit>().markHadithAsViewed());
            } else {
              unawaited(context.read<DailyContentCubit>().markSunnahAsViewed());
            }
            CustomRichContentDialog.show(
              context,
              title: item.header,
              bodyText: item.content,
              source: item.attribution,
              backgroundIcon: SolarIconsBold.book,
            );
          },
          onSharePressed: () async {
            if (!context.mounted) return;
            try {
              await AppShare.shareWidgetAsImage(
                context: context,
                widget: DailyContentShareCard(
                  title: item.header,
                  subTitle: item.content,
                  source: item.attribution,
                  type: type,
                ),
                imageName: 'daily_${type.name}_share',
              );
            } on Object catch (e, stack) {
              unawaited(
                AppLogger.localError(
                  'Share Error',
                  error: e,
                  stackTrace: stack,
                ),
              );
            }
          },
          onCopyPressed: () async {
            if (!context.mounted) return;
            try {
              final text =
                  '${item.header ?? ""}\n${item.content}\n${item.attribution ?? ""}';
              await Clipboard.setData(ClipboardData(text: text.trim()));
              if (context.mounted) {
                AppToast.show(context, 'تم النسخ بنجاح');
              }
            } on Object catch (e, stack) {
              unawaited(
                AppLogger.localError('Copy Error', error: e, stackTrace: stack),
              );
            }
          },
        );
      },
    );
  }
}
