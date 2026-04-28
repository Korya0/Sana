import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart';
import 'package:sana/features/hadith_search/utils/hadith_formatter.dart';

class HadithItemCard extends StatelessWidget {
  const HadithItemCard({required this.hadith, super.key, this.searchQuery});
  final HadithModel hadith;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final content = HadithFormatter.highlightSearchQuery(
      hadith.hadithContent,
      searchQuery,
    );
    final judgmentColor = HadithFormatter.getJudgmentColor(hadith.judgment);

    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.v16,
        left: AppSpacing.v16,
        right: AppSpacing.v16,
      ),
      decoration: featureCardDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        borderColor: judgmentColor.withValues(alpha: 0.25),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: AppSpacing.v4,
              child: Container(color: judgmentColor),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.v16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HadithContentWidget(
                    htmlContent: content,
                    judgmentColor: judgmentColor,
                  ),
                  const SizedBox(height: AppSpacing.v16),
                  HadithSearchShareAndFavoriteButtons(
                    hadith: hadith,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
