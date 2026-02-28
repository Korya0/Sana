import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_item_card.dart';
import 'package:sana/features/hadith_search/presentation/widgets/skeletonizer_loading_hadith_view.dart';
import 'package:sana/features/hadith_search/presentation/widgets/suggestions_grid.dart';

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
    return BlocListener<HadithCubit, HadithState>(
      listener: (context, state) {
        if (state is HadithSuccess && state.ahadith.isEmpty) {
          AppToast.show(context, 'لا توجد نتائج');
        }
      },
      child: BlocBuilder<HadithCubit, HadithState>(
        builder: (context, state) {
          if (state is HadithInitial) {
            return SliverToBoxAdapter(
              child: HadithSuggestionsGrid(
                onSuggestionTap: onSuggestionTap,
                isInitial: true,
              ),
            );
          }

          if (state is HadithLoading) {
            return const SkeletonizerLoadingHadithView();
          }

          if (state is HadithError) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorWidget(
                title: state.message,
                onRetry: onRetry,
              ),
            );
          }

          if (state is HadithSuccess) {
            if (state.ahadith.isEmpty) {
              return SliverToBoxAdapter(
                child: HadithSuggestionsGrid(
                  onSuggestionTap: onSuggestionTap,
                  isInitial: true,
                ),
              );
            }
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
                      if (index >= state.ahadith.length) {
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
                        hadith: state.ahadith[index],
                        searchQuery: state.query,
                      );
                    },
                    childCount: state.isLoadingMore
                        ? state.ahadith.length + 1
                        : state.ahadith.length,
                  ),
                ),
              ],
            );
          }

          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),
    );
  }
}
