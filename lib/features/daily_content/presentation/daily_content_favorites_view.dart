import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentFavoritesView extends StatefulWidget {
  const DailyContentFavoritesView({super.key});

  @override
  State<DailyContentFavoritesView> createState() =>
      _DailyContentFavoritesViewState();
}

class _DailyContentFavoritesViewState extends State<DailyContentFavoritesView> {
  List<DailyContentModel> favorites = [];
  final DailyContentRepository repository = sl<DailyContentRepository>();

  @override
  void initState() {
    super.initState();
    // الحصول على البيانات فوراً لمنع خطأ التعديل المتأخر
    favorites = repository.getFavorites();
  }

  void _loadFavorites() {
    if (!mounted) return;
    setState(() {
      favorites = repository.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CommonSliverAppBar(title: 'المفضلة اليومية'),
          if (favorites.isEmpty)
            SliverFillRemaining(
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
                      'لا يوجد عناصر في المفضلة بعد',
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
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = favorites[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _FavoriteCard(
                      item: item,
                      onDelete: () async {
                        await repository.toggleFavorite(item);
                        _loadFavorites();
                        if (!context.mounted) return;
                        unawaited(context.read<DailyContentCubit>().refresh());
                      },
                      onTap: () => _showDetails(context, item),
                    ),
                  );
                }, childCount: favorites.length),
              ),
            ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, DailyContentModel item) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => DailyContentDialog(
          title: item.header,
          subTitle: item.content,
          source: item.attribution,
          initialIsFavorite: true,
          onFavoriteToggle: () async {
            await repository.toggleFavorite(item);
            _loadFavorites();
            if (!context.mounted) return;
            unawaited(context.read<DailyContentCubit>().refresh());
          },
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.item,
    required this.onDelete,
    required this.onTap,
  });
  final DailyContentModel item;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: QuranCardBackground.decoration.copyWith(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            const QuranCardBackground(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.header ??
                              (item.content.length > 30
                                  ? '${item.content.substring(0, 30)}...'
                                  : item.content),
                          style: AppTextStyles.font16W600Gold(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          SolarIconsBold.heart,
                          color: Colors.white,
                          size: 24,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.content,
                    style: AppTextStyles.font16W400White(
                      context,
                    ).copyWith(height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  if (item.attribution != null) ...[
                    const SizedBox(height: 8),
                    const CustomAppDivider(),
                    const SizedBox(height: 8),
                    Text(
                      item.attribution!,
                      style: AppTextStyles.font14W400Gold(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
