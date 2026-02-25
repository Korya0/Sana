import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_explanation_dialog.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentBaseCard extends StatelessWidget {
  const DailyContentBaseCard({
    required this.item,
    required this.title,
    required this.icon,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onMarkViewed,
    required this.shareImageName,
    required this.copySuccessMessage,
    super.key,
  });

  final DailyContentModel item;
  final String title;
  final IconData icon;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onMarkViewed;
  final String shareImageName;
  final String copySuccessMessage;

  @override
  Widget build(BuildContext context) {
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
              icon,
              size: 140,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          InkWell(
            onTap: () => _showDetails(context),
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
                        title,
                        style: AppTextStyles.font18W700Gold(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: onFavoriteToggle,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isFavorite
                                  ? SolarIconsBold.heart
                                  : SolarIconsOutline.heart,
                              color: AppColors.gold,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _shareContent(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              SolarIconsOutline.share,
                              color: AppColors.gold,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _copyContent(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              SolarIconsOutline.copy,
                              color: AppColors.gold,
                              size: 24,
                            ),
                          ),
                          if (item.explanation != null) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                DailyContentExplanationDialog.show(
                                  context,
                                  explanation: item.explanation!,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'شرح الحديث',
                                style: AppTextStyles.font14W600Gold(context),
                              ),
                            ),
                          ],
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
                            text: item.content,
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
                                item.content,
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
  }

  void _showDetails(BuildContext context) {
    onMarkViewed();
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<DailyContentCubit>(),
          child: DailyContentDialog(
            title: item.header,
            subTitle: item.content,
            source: item.attribution,
            categoryLabel: item.category == DailyContentType.hadith
                ? 'حديث نبوي'
                : 'سنة مهجورة',
            initialIsFavorite: isFavorite,
            onFavoriteToggle: onFavoriteToggle,
            explanation: item.explanation,
          ),
        ),
      ),
    );
  }

  Future<void> _shareContent(BuildContext context) async {
    await WidgetToImage.shareWidget(
      context: context,
      widget: DailyContentShareCard(
        title: item.header,
        subTitle: item.content,
        source: item.attribution,
      ),
      imageName: shareImageName,
    );
  }

  Future<void> _copyContent(BuildContext context) async {
    final text =
        '${item.header ?? ""}\n${item.content}\n${item.attribution ?? ""}';
    await Clipboard.setData(ClipboardData(text: text.trim())).then((_) {
      if (context.mounted) {
        AppToast.show(context, copySuccessMessage);
      }
    });
  }
}
