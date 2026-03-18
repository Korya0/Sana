import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/common/widgets/app_empty_view.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_error_view.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_initial_view.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_success_list_view.dart';
import 'package:sana/features/hadith_search/presentation/widgets/skeletonizer_loading_hadith_view.dart';

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
          AppToast.show(context, AppStrings.noResults);
        }
      },
      child: BlocBuilder<HadithCubit, HadithState>(
        builder: (context, state) {
          if (state is HadithInitial) {
            return HadithInitialView(onSuggestionTap: onSuggestionTap);
          }

          if (state is HadithLoading) {
            return const SkeletonizerLoadingHadithView();
          }

          if (state is HadithError) {
            return HadithErrorView(message: state.message, onRetry: onRetry);
          }

          if (state is HadithSuccess) {
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
              query: state.query,
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
