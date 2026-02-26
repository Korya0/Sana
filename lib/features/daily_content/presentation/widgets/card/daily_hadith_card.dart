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

class DailyHadithCard extends StatelessWidget {
  const DailyHadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final hadith = state.dailyHadith;
        if (hadith == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          title: 'حديث اليوم',
          content: hadith.content,
          source: hadith.attribution,
          explanation: hadith.explanation,
          icon: FlutterIslamicIcons.mohammad,
          isFavorite: state.isHadithFavorite,
          onFavoriteToggle: () =>
              context.read<DailyContentCubit>().toggleHadithFavorite(),
          onTap: () {
            unawaited(context.read<DailyContentCubit>().markHadithAsViewed());
            unawaited(
              showDialog<void>(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<DailyContentCubit>(),
                  child: DailyContentDialog(
                    title: hadith.header,
                    subTitle: hadith.content,
                    source: hadith.attribution,
                    categoryLabel: 'حديث نبوي',
                    initialIsFavorite: state.isHadithFavorite,
                    onFavoriteToggle: () => context
                        .read<DailyContentCubit>()
                        .toggleHadithFavorite(),
                    explanation: hadith.explanation,
                  ),
                ),
              ),
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
            await Clipboard.setData(ClipboardData(text: text.trim())).then((_) {
              if (context.mounted) {
                AppToast.show(context, 'تم نسخ الحديث بنجاح');
              }
            });
          },
        );
      },
    );
  }
}
