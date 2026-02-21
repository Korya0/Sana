import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_item_card.dart';
import 'package:solar_icons/solar_icons.dart';

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
              const CommonSliverAppBar(title: 'أحاديثي المفضلة'),
              if (favorites.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          SolarIconsOutline.heart,
                          size: 80,
                          color: AppColors.gold.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد أحاديث في المفضلة بعد',
                          style: AppTextStyles.font16W600White(
                            context,
                          ).copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
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
