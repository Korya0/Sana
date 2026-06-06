import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/common/favorites/custom_favorite_toggle_button.dart';
import 'package:sana/core/common/overlays/dialog/daily_content_explanation_dialog.dart';
import 'package:sana/core/common/overlays/toast/favorite_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

class DailyContentBaseCard extends StatelessWidget {
  const DailyContentBaseCard({
    required this.content,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.onSharePressed,
    required this.onCopyPressed,
    super.key,
    this.source,
    this.explanation,
    this.isFavorite,
    this.onFavoriteToggle,
    this.footerText,
  });

  final String content;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onSharePressed;
  final VoidCallback onCopyPressed;
  final String? source;
  final String? explanation;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;
  final String? footerText;

  // aesthetic dimensions
  static const double _bgIconOffset = -10;
  static const double _bgIconSize = 140;
  static const double _contentLineHeight = 1.4;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: customAppCardDecoration(context).copyWith(
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
      ),
      child: Stack(
        children: [
          // Standard Background Icon
          Positioned(
            right: _bgIconOffset,
            bottom: _bgIconOffset,
            child: Icon(
              icon,
              size: _bgIconSize.r(context),
              color: context.color.textPrimary.withValues(alpha: 0.05),
            ),
          ),

          // Content
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.v20,
                  vertical: AppSpacing.v12,
                ),
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.font14W700primary(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.v8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isFavorite != null &&
                                onFavoriteToggle != null) ...[
                              CustomFavoriteToggleButton(
                                onPressed: () {
                                  onFavoriteToggle!();
                                  FavoriteToast.showFavoriteToast(
                                    context,
                                    isAdded: !isFavorite!,
                                  );
                                },
                                iconSize: 16.r(context),
                                isFav: isFavorite!,
                              ),
                              const SizedBox(width: AppSpacing.v8),
                            ],
                            CombinedShareCopyButton(
                              onSharePressed: onSharePressed,
                              onCopyPressed: onCopyPressed,
                              iconSize: 16.r(context),
                            ),
                            if (explanation != null) ...[
                              const SizedBox(width: AppSpacing.v8),
                              TextButton(
                                onPressed: () {
                                  DailyContentExplanationDialog.show(
                                    context,
                                    explanation: explanation!,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.v8,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppStrings.explanation,
                                  style: AppTextStyles.font14W700primary(
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.v8),
                    // Content Area
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final textStyle = AppTextStyles.font14W500White(
                            context,
                          ).copyWith(height: _contentLineHeight);
                          final textPainter = TextPainter(
                            text: TextSpan(text: content, style: textStyle),
                            maxLines: 2,
                            textDirection: TextDirection.rtl,
                          )..layout(maxWidth: constraints.maxWidth);

                          final hasOverflow = textPainter.didExceedMaxLines;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  content,
                                  style: textStyle,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hasOverflow || footerText != null) ...[
                                const SizedBox(height: AppSpacing.v4),
                                Text(
                                  footerText ?? AppStrings.pressHereToSeeMore,
                                  style:
                                      AppTextStyles.font11W700(
                                        context,
                                      ).copyWith(
                                        color: context.color.primary.withValues(
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
          ),
        ],
      ),
    );
  }
}


