import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/favorites/no_favorites_yet.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
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
          var favorites = <HadithModel>[];
          if (state is HadithFavoritesLoaded) {
            favorites = state.favorites;
          }

          return CustomScrollView(
            slivers: [
              const CommonSliverAppBar(title: AppStrings.myFavoriteHadiths),
              AnimatedSliverList<HadithModel>(
                dataList: favorites,
                listPadding: EdgeInsets.zero,
                emptyStateWidget: const NoFavoritesYet(),
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
