import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart';
import 'package:sana/features/hadith_search/utils/hadith_formatter.dart';

class HadithItemCard extends StatelessWidget {
  const HadithItemCard({required this.hadith, super.key, this.searchQuery});
  final HadithEntity hadith;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final content = HadithFormatter.highlightSearchQuery(
      hadith.hadithContent,
      searchQuery,
    );
    final judgmentColor = HadithFormatter.getJudgmentColor(hadith.judgment);

    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: judgmentColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(color: judgmentColor),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HadithContentWidget(
                    htmlContent: content,
                    judgmentColor: judgmentColor,
                  ),
                  const SizedBox(height: 16),
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
