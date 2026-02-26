import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_explanation_dialog.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
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
            decoration: QuranCardBackground.decoration,
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  const QuranCardBackground(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.categoryLabel != null) ...[
                          Text(
                            widget.categoryLabel!,
                            style: AppTextStyles.font14W400Gold(context),
                          ),
                          const SizedBox(height: 8),
                        ],
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
                        if (widget.explanation != null) ...[
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              DailyContentExplanationDialog.show(
                                context,
                                explanation: widget.explanation!,
                              );
                            },
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
                                  SolarIconsOutline.notes,
                                  color: AppColors.gold,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'شرح الحديث',
                                  style: AppTextStyles.font14W600Gold(context),
                                ),
                              ],
                            ),
                          ),
                        ],
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
