import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
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

  final List<HadithEntity> hadiths;
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= hadiths.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      color: AppColors.gold,
                    ),
                  ),
                );
              }
              return HadithItemCard(
                hadith: hadiths[index],
                searchQuery: query,
              );
            },
            childCount: isLoadingMore ? hadiths.length + 1 : hadiths.length,
          ),
        ),
      ],
    );
  }
}
