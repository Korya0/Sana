import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_favorites_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_favorites_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_favorite_card.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentFavoritesView extends StatelessWidget {
  const DailyContentFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CommonSliverAppBar(title: AppStrings.dailyContentFavorites),
          BlocBuilder<DailyFavoritesCubit, DailyFavoritesState>(
            builder: (context, state) {
              return AnimatedSliverList<DailyContentModel>(
                dataList: state.favorites,
                emptyStateWidget: const NoFavoriteYet(),
                listPadding: const EdgeInsets.only(
                  bottom: AppSpacing.v16,
                  left: AppSpacing.v16,
                  right: AppSpacing.v16,
                ),
                keyFinder: (item, index) => ValueKey(item.hashCode),
                itemContentBuilder: (context, item, index) =>
                    DailyContentFavoriteCard(
                      item: item,
                      onDelete: () => context
                          .read<DailyFavoritesCubit>()
                          .toggleFavorite(item),
                      onTap: () => _showContentDetails(context, item),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showContentDetails(BuildContext context, DailyContentModel item) {
    CustomRichContentDialog.show(
      context,
      title: item.header,
      bodyText: item.content,
      source: item.attribution,
      backgroundIcon: SolarIconsBold.book,
    );
  }
}
