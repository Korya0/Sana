import 'package:flutter/material.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_results_builder.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_search_sliver_app_bar.dart';

class HadithSearchBody extends StatelessWidget {
  const HadithSearchBody({
    required this.scrollController,
    required this.isSearchVisible,
    required this.autoFocus,
    required this.searchController,
    required this.onToggleSearch,
    required this.onSearchChanged,
    required this.onSuggestionTap,
    required this.onRetry,
    super.key,
  });

  final ScrollController scrollController;
  final bool isSearchVisible;
  final bool autoFocus;
  final TextEditingController searchController;
  final VoidCallback onToggleSearch;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        HadithSearchSliverAppBar(
          isSearchVisible: isSearchVisible,
          autoFocus: autoFocus,
          searchController: searchController,
          onToggleSearch: onToggleSearch,
          onSearchChanged: onSearchChanged,
        ),
        HadithSearchResultsBuilder(
          onSuggestionTap: onSuggestionTap,
          onRetry: onRetry,
        ),
      ],
    );
  }
}
