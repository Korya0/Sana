import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart';
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
              AnimatedSliverList<HadithEntity>(
                dataList: favorites,
                listPadding: EdgeInsets.zero,
                emptyStateWidget: const NoFavoriteYet(),
                itemContentBuilder: (context, item, index) =>
                    HadithItemCard(hadith: item),
              ),
            ],
          );
        },
      ),
    );
  }
}
