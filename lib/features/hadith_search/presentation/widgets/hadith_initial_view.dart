import 'package:flutter/material.dart';
import 'package:sana/features/hadith_search/presentation/widgets/suggestions_grid.dart';

class HadithInitialView extends StatelessWidget {
  const HadithInitialView({required this.onSuggestionTap, super.key});
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HadithSuggestionsGrid(
        onSuggestionTap: onSuggestionTap,
        isInitial: true,
      ),
    );
  }
}
