import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/cusotm_app_card_decoration.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentDialog extends StatefulWidget {
  const DailyContentDialog({
    required this.subTitle,
    required this.onFavoriteToggle,
    super.key,
    this.title,
    this.source,
    this.categoryLabel,
    this.initialIsFavorite = false,
    this.explanation,
  });
  final String? title;
  final String subTitle;
  final String? source;
  final String? categoryLabel;
  final String? explanation;
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
            decoration: customAppCardDecoration(),
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -20,
                    child: Icon(
                      SolarIconsBold.book,
                      size: 150,
                      color: AppColors.white.withValues(alpha: 0.05),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header Row with Category and Share/Copy
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.categoryLabel ?? '',
                              style: AppTextStyles.font14W400Gold(context),
                            ),
                            CombinedShareCopyButton(
                              onSharePressed: () async =>
                                  WidgetToImage.shareWidget(
                                    context: context,
                                    widget: DailyContentShareCard(
                                      title: widget.title,
                                      subTitle: widget.subTitle,
                                      source: widget.source,
                                    ),
                                    imageName: 'daily_content_share',
                                  ),
                              onCopyPressed: () async {
                                final text =
                                    '${widget.title ?? ""}\n${widget.subTitle}\n${widget.source ?? ""}';
                                await Clipboard.setData(
                                  ClipboardData(text: text.trim()),
                                ).then((_) {
                                  if (context.mounted) {
                                    AppToast.show(
                                      context,
                                      AppStrings.copiedToClipboard,
                                    );
                                  }
                                });
                              },
                              iconSize: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        if (widget.title != null &&
                            widget.title!.isNotEmpty) ...[
                          Text(
                            widget.title!,
                            style: AppTextStyles.font22W700Gold(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Body
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
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            backgroundColor: AppColors.gold.withValues(
                              alpha: 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                SolarIconsOutline.closeCircle,
                                color: AppColors.gold,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppStrings.close,
                                style: AppTextStyles.font14W600Gold(context),
                              ),
                            ],
                          ),
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
}
