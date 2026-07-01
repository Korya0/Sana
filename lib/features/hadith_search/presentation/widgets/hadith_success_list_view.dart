import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_item_card.dart';
import 'package:sana/features/hadith_search/presentation/widgets/suggestions_grid.dart';

class HadithSuccessListView extends StatelessWidget {
  const HadithSuccessListView({
    required this.hadiths,
    required this.isLoadingMore,
    required this.onSuggestionTap,
    super.key,
  });

  final List<HadithEntity> hadiths;
  final bool isLoadingMore;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: HadithSuggestionsGrid(
            onSuggestionTap: onSuggestionTap,
          ),
        ),
        AnimatedSliverList<HadithEntity>(
          dataList: hadiths,
          listPadding: EdgeInsets.zero,
          keyFinder: (hadith, index) => ValueKey(hadith.hashCode),
          itemContentBuilder: (context, item, index) => HadithItemCard(
            hadith: item,
          ),
          footerSliver: isLoadingMore
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.v16),
                      child: CircularProgressIndicator(
                        color: context.color.primary,
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
