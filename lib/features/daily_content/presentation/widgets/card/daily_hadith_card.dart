import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyHadithCard extends StatelessWidget {
  const DailyHadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final hadith = state.dailyHadith;
        if (hadith == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          decoration: QuranCardBackground.decoration,
          child: Stack(
            children: [
              // Standard Background Icon
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  FlutterIslamicIcons.mohammad,
                  size: 140,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              InkWell(
                onTap: () => _showDetails(context, hadith, state),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الحديث اليومي',
                            style: AppTextStyles.font18W700Gold(context),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => context
                                    .read<DailyContentCubit>()
                                    .toggleHadithFavorite(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  state.isHadithFavorite
                                      ? SolarIconsBold.heart
                                      : SolarIconsOutline.heart,
                                  color: state.isHadithFavorite
                                      ? Colors.white
                                      : AppColors.gold,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CombinedShareCopyButton(
                                iconSize: 24,
                                onSharePressed: () =>
                                    _shareHadith(context, hadith),
                                onCopyPressed: () =>
                                    _copyHadith(context, hadith),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Content Area
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final textStyle = AppTextStyles.font16W500White(
                              context,
                            ).copyWith(height: 1.4);
                            final textPainter = TextPainter(
                              text: TextSpan(
                                text: hadith.content,
                                style: textStyle,
                              ),
                              maxLines: 2,
                              textDirection: TextDirection.rtl,
                            )..layout(maxWidth: constraints.maxWidth);

                            final hasOverflow = textPainter.didExceedMaxLines;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    hadith.content,
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (hasOverflow) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'اضغط هنا لتري البقية',
                                    style: AppTextStyles.font12W500Gold(context)
                                        .copyWith(
                                          color: AppColors.gold.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetails(
    BuildContext context,
    DailyContentModel hadith,
    DailyContentState state,
  ) {
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
            initialIsFavorite: state.isHadithFavorite,
            onFavoriteToggle: () =>
                context.read<DailyContentCubit>().toggleHadithFavorite(),
          ),
        ),
      ),
    );
  }

  Future<void> _shareHadith(
    BuildContext context,
    DailyContentModel hadith,
  ) async {
    await WidgetToImage.shareWidget(
      context: context,
      widget: DailyContentShareCard(
        title: hadith.header,
        subTitle: hadith.content,
        source: hadith.attribution,
      ),
      imageName: 'daily_hadith_share',
    );
  }

  Future<void> _copyHadith(
    BuildContext context,
    DailyContentModel hadith,
  ) async {
    final text =
        '${hadith.header ?? ""}\n${hadith.content}\n${hadith.attribution ?? ""}';
    await Clipboard.setData(ClipboardData(text: text.trim())).then((_) {
      if (context.mounted) {
        AppToast.show(context, 'تم نسخ الحديث بنجاح');
      }
    });
  }
}
