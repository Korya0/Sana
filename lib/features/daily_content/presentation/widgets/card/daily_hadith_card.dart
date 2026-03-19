import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/overlays/dialog/custom_rich_content_dialog.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_state.dart';
import 'package:sana/features/sharing/logic/widget_to_image.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_base_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyHadithCard extends StatelessWidget {
  const DailyHadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final hadith = state.dailyHadith;
        if (hadith == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          title: AppStrings.hadithOfTheDay,
          content: hadith.content,
          source: hadith.attribution,
          explanation: hadith.explanation,
          icon: FlutterIslamicIcons.mohammad,
          isFavorite: state.isHadithFavorite,
          onFavoriteToggle: () =>
              context.read<DailyContentCubit>().toggleHadithFavorite(),
          onTap: () {
            unawaited(context.read<DailyContentCubit>().markHadithAsViewed());
            CustomRichContentDialog.show(
              context,
              title: hadith.header,
              bodyText: hadith.content,
              source: hadith.attribution,
              backgroundIcon: SolarIconsBold.book,
            );
          },
          onSharePressed: () async => WidgetToImage.shareWidget(
            context: context,
            widget: DailyContentShareCard(
              title: hadith.header,
              subTitle: hadith.content,
              source: hadith.attribution,
            ),
            imageName: 'daily_hadith_share',
          ),
          onCopyPressed: () async {
            final text =
                '${hadith.header ?? ""}\n${hadith.content}\n${hadith.attribution ?? ""}';
            await Clipboard.setData(ClipboardData(text: text.trim()));
          },
        );
      },
    );
  }
}
