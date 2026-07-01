import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/utils/hadith_ui_mapper.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart';

class HadithItemCard extends StatelessWidget {
  const HadithItemCard({required this.hadith, super.key});
  final HadithEntity hadith;

  @override
  Widget build(BuildContext context) {
    final judgmentColor = hadith.judgmentType.getColor(context);

    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.v16,
        left: AppSpacing.v16,
        right: AppSpacing.v16,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: featureCardDecoration(
        context: context,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        borderColor: judgmentColor.withValues(alpha: 0.25),
      ),
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
                  htmlContent: hadith.effectiveContent,
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
    );
  }
}
