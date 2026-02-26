import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_base_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';

class DailySunnahCard extends StatelessWidget {
  const DailySunnahCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final sunnah = state.dailySunnah;
        if (sunnah == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          title: 'سنة مهجورة',
          content: sunnah.content,
          source: sunnah.attribution,
          explanation: sunnah.explanation,
          icon: FlutterIslamicIcons.prayer,
          isFavorite: state.isSunnahFavorite,
          onFavoriteToggle: () =>
              context.read<DailyContentCubit>().toggleSunnahFavorite(),
          onTap: () {
            unawaited(context.read<DailyContentCubit>().markSunnahAsViewed());
            unawaited(
              showDialog<void>(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<DailyContentCubit>(),
                  child: DailyContentDialog(
                    title: sunnah.header,
                    subTitle: sunnah.content,
                    source: sunnah.attribution,
                    categoryLabel: 'سنة مهجورة',
                    initialIsFavorite: state.isSunnahFavorite,
                    onFavoriteToggle: () => context
                        .read<DailyContentCubit>()
                        .toggleSunnahFavorite(),
                    explanation: sunnah.explanation,
                  ),
                ),
              ),
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
            await Clipboard.setData(ClipboardData(text: text.trim())).then((_) {
              if (context.mounted) {
                AppToast.show(context, 'تم نسخ المحتوى بنجاح');
              }
            });
          },
        );
      },
    );
  }
}
