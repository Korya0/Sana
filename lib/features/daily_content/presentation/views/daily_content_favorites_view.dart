import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/common/favorites/custom_favorite_toggle_button.dart';
import 'package:sana/core/common/favorites/no_favorites_yet.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/common/overlays/toast/favorite_toast.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/cusotm_app_card_decoration.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_dialog.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/features/daily_content/presentation/widgets/daily_content_explanation_dialog.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentFavoritesView extends StatefulWidget {
  const DailyContentFavoritesView({super.key});

  @override
  State<DailyContentFavoritesView> createState() =>
      _DailyContentFavoritesViewState();
}

class _DailyContentFavoritesViewState extends State<DailyContentFavoritesView> {
  final DailyContentRepository repository = sl<DailyContentRepository>();
  List<DailyContentModel> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllFavorites();
  }

  void _loadAllFavorites() {
    setState(() {
      favorites = repository.getFavorites();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CommonSliverAppBar(title: AppStrings.dailyContentFavorites),
        ],
        body: _buildContentList(),
      ),
    );
  }

  Widget _buildContentList() {
    return CustomScrollView(
      slivers: [
        AnimatedSliverList<DailyContentModel>(
          dataList: favorites,
          emptyStateWidget: const NoFavoritesYet(),
          listPadding: const EdgeInsets.only(bottom: 16),
          keyFinder: (item, index) => ValueKey(item.hashCode),
          itemContentBuilder: (context, item, index) => _FavoriteCard(
            item: item,
            onDelete: () async {
              await repository.toggleFavorite(item);
              _loadAllFavorites();
              if (!context.mounted) return;
              unawaited(context.read<DailyContentCubit>().refresh());
            },
            onTap: () => _showContentDetails(context, item),
          ),
        ),
      ],
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
          explanation: item.explanation,
          categoryLabel: item.category == DailyContentType.hadith
              ? AppStrings.hadith
              : AppStrings.sunnah,
          initialIsFavorite: true,
          onFavoriteToggle: () async {
            await repository.toggleFavorite(item);
            if (!mounted) return;
            _loadAllFavorites();
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
        decoration: customAppCardDecoration().copyWith(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -20,
              child: Icon(
                SolarIconsBold.book,
                size: 150,
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
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
                            Row(
                              children: [
                                CustomFavoriteToggleButton(
                                  onPressed: () {
                                    onDelete();
                                    FavoriteToast.showFavoriteToast(
                                      context,
                                      false,
                                    ); // Always false because we are deleting in this view
                                  },
                                  isFav:
                                      true, // Always true since it's the favorites view
                                ),
                                const SizedBox(width: 8),
                                CombinedShareCopyButton(
                                  onSharePressed: () async =>
                                      WidgetToImage.shareWidget(
                                        context: context,
                                        widget: DailyContentShareCard(
                                          title: item.header,
                                          subTitle: item.content,
                                          source: item.attribution,
                                        ),
                                        imageName:
                                            'share_favorite_${item.hashCode}',
                                      ),
                                  onCopyPressed: () async => Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          '${item.header ?? ""}\n${item.content}\n${item.attribution ?? ""}'
                                              .trim(),
                                    ),
                                  ),
                                ),
                                if (item.explanation != null) ...[
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      DailyContentExplanationDialog.show(
                                        context,
                                        explanation: item.explanation!,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      AppStrings.explanation,
                                      style: AppTextStyles.font14W600Gold(
                                        context,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
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
