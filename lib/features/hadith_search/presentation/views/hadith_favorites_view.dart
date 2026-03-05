import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_state.dart';
import 'package:sana/core/common/widgets/favorites/no_hadith_favorites_yet.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_item_card.dart';

class HadithFavoritesView extends StatelessWidget {
  const HadithFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HadithFavoritesCubit, HadithFavoritesState>(
        builder: (context, state) {
          var favorites = <HadithEntity>[];
          if (state is HadithFavoritesLoaded) {
            favorites = state.favorites;
          }

          return CustomScrollView(
            slivers: [
              const CommonSliverAppBar(title: AppStrings.myFavoriteHadiths),
              if (favorites.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: NoHadithFavoritesYet(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return HadithItemCard(hadith: favorites[index]);
                    }, childCount: favorites.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
