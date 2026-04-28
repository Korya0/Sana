import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/overlays/dialog/custom_rich_content_dialog.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharing/logic/widget_to_image.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_state.dart';
import 'package:sana/core/common/widgets/card/daily_content_base_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class DailySunnahCard extends StatelessWidget {
  const DailySunnahCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final sunnah = state.dailySunnah;
        if (sunnah == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          title: AppStrings.sunnah,
          content: sunnah.content,
          source: sunnah.attribution,
          explanation: sunnah.explanation,
          icon: FlutterIslamicIcons.prayer,
          isFavorite: state.isSunnahFavorite,
          onFavoriteToggle: () =>
              context.read<DailyContentCubit>().toggleSunnahFavorite(),
          onTap: () {
            unawaited(context.read<DailyContentCubit>().markSunnahAsViewed());
            CustomRichContentDialog.show(
              context,
              title: sunnah.header,
              bodyText: sunnah.content,
              source: sunnah.attribution,
              backgroundIcon: SolarIconsBold.book,
            );
          },
          onSharePressed: () async => WidgetToImage.shareWidget(
            context: context,
            widget: DailyContentShareCard(
              title: sunnah.header,
              subTitle: sunnah.content,
              source: sunnah.attribution,
            ),
            imageName: 'daily_sunnah_share',
          ),
          onCopyPressed: () async {
            final text =
                '${sunnah.header ?? ""}\n${sunnah.content}\n${sunnah.attribution ?? ""}';
            await Clipboard.setData(ClipboardData(text: text.trim()));
          },
        );
      },
    );
  }
}
