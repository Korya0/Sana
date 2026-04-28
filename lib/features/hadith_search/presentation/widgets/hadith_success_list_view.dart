import 'package:flutter/material.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_item_card.dart';
import 'package:sana/features/hadith_search/presentation/widgets/suggestions_grid.dart';

class HadithSuccessListView extends StatelessWidget {
  const HadithSuccessListView({
    required this.hadiths,
    required this.query,
    required this.isLoadingMore,
    required this.onSuggestionTap,
    super.key,
  });

  final List<HadithModel> hadiths;
  final String query;
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
        AnimatedSliverList<HadithModel>(
          dataList: hadiths,
          listPadding: EdgeInsets.zero,
          keyFinder: (hadith, index) => ValueKey(hadith.hashCode),
          itemContentBuilder: (context, item, index) => HadithItemCard(
            hadith: item,
            searchQuery: query,
          ),
          footerSliver: isLoadingMore
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.v16),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
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
