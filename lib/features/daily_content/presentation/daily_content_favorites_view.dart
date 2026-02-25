import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/data/repositories/asma_ul_husna_repository.dart';
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
  List<AsmaulHusnaModel> asmaFavorites = [];
  final DailyContentRepository repository = sl<DailyContentRepository>();
  final IAsmaUlHusnaRepository asmaRepository = sl<IAsmaUlHusnaRepository>();

  @override
  void initState() {
    super.initState();
    _loadAllFavorites();
  }

  void _loadAllFavorites() {
    if (!mounted) return;
    setState(() {
      favorites = repository.getFavorites();
      asmaFavorites = asmaRepository.getAsmaFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const CommonSliverAppBar(
              title: 'المفضلة اليومية',
              bottom: TabBar(
                tabs: [
                  Tab(text: 'محتوى اليوم'),
                  Tab(text: 'الأسماء الحسنى'),
                ],
                indicatorColor: AppColors.gold,
                labelColor: AppColors.gold,
                unselectedLabelColor: Colors.grey,
              ),
            ),
          ],
          body: TabBarView(
            children: [
              // Tab 1: Hadith & Sunnah
              _buildContentList(),
              // Tab 2: Asma Ul Husna
              _buildAsmaList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentList() {
    if (favorites.isEmpty) {
      return _buildEmptyState('لا يوجد محتوى في المفضلة بعد');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final item = favorites[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _FavoriteCard(
            item: item,
            onDelete: () async {
              await repository.toggleFavorite(item);
              _loadAllFavorites();
              if (!context.mounted) return;
              unawaited(context.read<DailyContentCubit>().refresh());
            },
            onTap: () => _showContentDetails(context, item),
          ),
        );
      },
    );
  }

  Widget _buildAsmaList() {
    if (asmaFavorites.isEmpty) {
      return _buildEmptyState('لا يوجد أسماء في المفضلة بعد');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: asmaFavorites.length,
      itemBuilder: (context, index) {
        final item = asmaFavorites[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _AsmaFavoriteCard(
            item: item,
            onDelete: () async {
              await asmaRepository.toggleAsmaFavorite(item);
              _loadAllFavorites();
              if (!context.mounted) return;
              unawaited(context.read<DailyContentCubit>().refresh());
            },
            onTap: () => _showAsmaDetails(context, item),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
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
            message,
            style: AppTextStyles.font16W600White(
              context,
            ).copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  void _showContentDetails(BuildContext context, DailyContentModel item) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => DailyContentDialog(
          title: item.header,
          subTitle: item.content,
          source: item.attribution,
          categoryLabel: item.category == DailyContentType.hadith
              ? 'حديث نبوي'
              : 'سنة مهجورة',
          initialIsFavorite: true,
          onFavoriteToggle: () async {
            await repository.toggleFavorite(item);
            _loadAllFavorites();
            if (!context.mounted) return;
            unawaited(context.read<DailyContentCubit>().refresh());
          },
        ),
      ),
    );
  }

  void _showAsmaDetails(BuildContext context, AsmaulHusnaModel item) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => DailyContentDialog(
          title: item.name,
          subTitle: item.meaningDetailed,
          source: item.meaningBrief,
          categoryLabel: 'الأسماء الحسنى',
          initialIsFavorite: true,
          onFavoriteToggle: () async {
            await asmaRepository.toggleAsmaFavorite(item);
            _loadAllFavorites();
            if (!context.mounted) return;
            unawaited(context.read<DailyContentCubit>().refresh());
          },
        ),
      ),
    );
  }
}

class _AsmaFavoriteCard extends StatelessWidget {
  const _AsmaFavoriteCard({
    required this.item,
    required this.onDelete,
    required this.onTap,
  });
  final AsmaulHusnaModel item;
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الأسماء الحسنى',
                              style: AppTextStyles.font12W500Gold(context),
                            ),
                            Text(
                              item.name,
                              style: AppTextStyles.font26W700GoldQuran(
                                context,
                              ).copyWith(fontSize: 24),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                    item.meaningBrief,
                    style: AppTextStyles.font16W400White(
                      context,
                    ).copyWith(height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  const CustomAppDivider(),
                  const SizedBox(height: 8),
                  Text(
                    item.meaningDetailed,
                    style: AppTextStyles.font14W400Gold(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.category == DailyContentType.hadith
                                  ? 'حديث نبوي'
                                  : 'سنة مهجورة',
                              style: AppTextStyles.font12W500Gold(context),
                            ),
                            Text(
                              item.header ??
                                  (item.content.length > 30
                                      ? '${item.content.substring(0, 30)}...'
                                      : item.content),
                              style: AppTextStyles.font16W600Gold(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
