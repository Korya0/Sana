import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_search/hadith_search_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_error_view.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_success_list_view.dart';
import 'package:sana/features/hadith_search/presentation/widgets/skeletonizer_loading_hadith_view.dart';
import 'package:sana/features/hadith_search/presentation/widgets/suggestions_grid.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithSearchResultsBuilder extends StatelessWidget {
  const HadithSearchResultsBuilder({
    required this.onSuggestionTap,
    required this.onRetry,
    super.key,
  });
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HadithSearchCubit, HadithSearchState>(
      listener: (context, state) {
        if (state is HadithSearchSuccess && state.ahadith.isEmpty) {
          AppToast.show(context, AppStrings.noResults);
        }
      },
      child: BlocBuilder<HadithSearchCubit, HadithSearchState>(
        builder: (context, state) {
          if (state is HadithSearchInitial) {
            return SliverToBoxAdapter(
              child: HadithSuggestionsGrid(
                onSuggestionTap: onSuggestionTap,
                isInitial: true,
              ),
            );
          }

          if (state is HadithSearchLoading) {
            return const SkeletonizerLoadingHadithView();
          }

          if (state is HadithSearchError) {
            return HadithErrorView(message: state.message, onRetry: onRetry);
          }

          if (state is HadithSearchSuccess) {
            if (state.ahadith.isEmpty) {
              return const SliverFillRemaining(
                child: AppEmptyView(
                  message: AppStrings.noResults,
                  icon: SolarIconsBold.minimalisticMagnifier,
                ),
              );
            }
            return HadithSuccessListView(
              hadiths: state.ahadith,
              isLoadingMore: state.isLoadingMore,
              onSuggestionTap: onSuggestionTap,
            );
          }

          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),
    );
  }
}
