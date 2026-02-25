import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/combined_share_copy_button.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentDialog extends StatefulWidget {
  const DailyContentDialog({
    required this.subTitle,
    required this.onFavoriteToggle,
    super.key,
    this.title,
    this.source,
    this.initialIsFavorite = false,
  });
  final String? title;
  final String subTitle;
  final String? source;
  final bool initialIsFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  State<DailyContentDialog> createState() => _DailyContentDialogState();
}

class _DailyContentDialogState extends State<DailyContentDialog> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialIsFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Content Card
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: QuranCardBackground.decoration,
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  const QuranCardBackground(),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null &&
                            widget.title!.isNotEmpty) ...[
                          Text(
                            widget.title!,
                            style: AppTextStyles.font22W700Gold(context),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Body
                        Column(
                          children: [
                            Text(
                              widget.subTitle,
                              style: AppTextStyles.font26W700GoldQuran(
                                context,
                              ).copyWith(color: AppColors.white),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            if (widget.source != null &&
                                widget.source!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                widget.source!,
                                style: AppTextStyles.font14W400Gold(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                    widget.onFavoriteToggle();
                                  },
                                  icon: Icon(
                                    isFavorite
                                        ? SolarIconsBold.heart
                                        : SolarIconsOutline.heart,
                                    color: isFavorite
                                        ? Colors.white
                                        : AppColors.gold,
                                    size: 28,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    context.pop(); // Close dialog first
                                    await context.pushNamed(
                                      AppRoutes.dailyContentFavorites,
                                    );
                                  },
                                  child: Text(
                                    'عرض الكل',
                                    style:
                                        AppTextStyles.font14W600White(
                                          context,
                                        ).copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            CombinedShareCopyButton(
                              isCombined: false,
                              iconSize: 26,
                              onSharePressed: () =>
                                  unawaited(_shareContent(context)),
                              onCopyPressed: () =>
                                  unawaited(_copyContent(context)),
                            ),
                          ],
                        ),
                      ],
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

  Future<void> _shareContent(BuildContext context) async {
    // 1. Create the widget to be captured
    final shareWidget = DailyContentShareCard(
      title: widget.title,
      subTitle: widget.subTitle,
      source: widget.source,
    );

    // 2. Use WidgetToImage util
    await WidgetToImage.shareWidget(
      context: context,
      widget: shareWidget,
      imageName: 'daily_content_share',
    );
  }

  Future<void> _copyContent(BuildContext context) async {
    final textToCopy = widget.title != null
        ? '${widget.title}\n${widget.subTitle}\n${widget.source ?? ''}'
        : '${widget.subTitle}\n${widget.source ?? ''}';

    await Clipboard.setData(ClipboardData(text: textToCopy.trim())).then((_) {
      if (context.mounted) {
        AppToast.show(context, 'تم النسخ بنجاح');
      }
    });
  }
}
