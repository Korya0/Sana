import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_share.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentFavoriteCard extends StatelessWidget {
  const DailyContentFavoriteCard({
    required this.item,
    required this.onDelete,
    required this.onTap,
    super.key,
  });
  final DailyContentModel item;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  static const double _bgIconRight = -10;
  static const double _bgIconBottom = -20;
  static const double _bgIconSize = 150;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: customAppCardDecoration(context).copyWith(
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: _bgIconRight,
              bottom: _bgIconBottom,
              child: Icon(
                SolarIconsBold.book,
                size: _bgIconSize,
                color: context.color.textPrimary.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.v16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.header ?? item.shortContent,
                                style: AppTextStyles.font16W700(
                                  context,
                                ).copyWith(color: context.color.textAccent),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                CustomFavoriteToggleButton(
                                  onPressed: () {
                                    onDelete();
                                    FavoriteToast.showFavoriteToast(
                                      context,
                                      isAdded: false,
                                    );
                                  },
                                  isFav: true,
                                ),
                                const SizedBox(width: AppSpacing.v8),
                                CombinedShareCopyButton(
                                  onSharePressed: () async {
                                    if (!context.mounted) return;
                                    try {
                                      await AppShare.shareWidgetAsImage(
                                        context: context,
                                        widget: DailyContentShareCard(
                                          title: item.header,
                                          subTitle: item.content,
                                          source: item.attribution,
                                        ),
                                        imageName: 'share_favorite_${item.hashCode}',
                                      );
                                    } on Exception catch (e, stack) {
                                      unawaited(AppLogger.localError('Share Error', error: e, stackTrace: stack));
                                    }
                                  },
                                  onCopyPressed: () async {
                                    try {
                                      await Clipboard.setData(
                                        ClipboardData(
                                          text: '${item.header ?? ""}\n${item.content}\n${item.attribution ?? ""}'.trim(),
                                        ),
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('تم النسخ بنجاح')),
                                        );
                                      }
                                    } on Exception catch (e, stack) {
                                      unawaited(AppLogger.localError('Copy Error', error: e, stackTrace: stack));
                                    }
                                  },
                                ),
                                if (item.explanation != null) ...[
                                  const SizedBox(width: AppSpacing.v8),
                                  TextButton(
                                    onPressed: () {
                                      DailyContentExplanationDialog.show(
                                        context,
                                        explanation: item.explanation!,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.v8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      AppStrings.explanation,
                                      style: AppTextStyles.font14W700(context).copyWith(
                                        color: context.color.textAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.v8),
                  Text(
                    item.content,
                    style: AppTextStyles.font16W500(context)
                        .copyWith(color: context.color.textPrimary)
                        .copyWith(height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  if (item.attribution != null) ...[
                    const SizedBox(height: AppSpacing.v8),
                    const CustomAppDivider(),
                    const SizedBox(height: AppSpacing.v8),
                    Text(
                      item.attribution!,
                      style: AppTextStyles.font14W500(context).copyWith(color: context.color.textAccent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
