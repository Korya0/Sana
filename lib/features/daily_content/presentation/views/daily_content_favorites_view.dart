import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/common/favorites/custom_favorite_toggle_button.dart';
import 'package:sana/core/common/favorites/no_favorites_yet.dart';
import 'package:sana/core/common/overlays/dialog/custom_rich_content_dialog.dart';
import 'package:sana/core/common/overlays/dialog/daily_content_explanation_dialog.dart';
import 'package:sana/core/common/overlays/toast/favorite_toast.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentFavoritesView extends StatefulWidget {
  const DailyContentFavoritesView({super.key});

  @override
  State<DailyContentFavoritesView> createState() =>
      _DailyContentFavoritesViewState();
}

class _DailyContentFavoritesViewState extends State<DailyContentFavoritesView> {
  final IDailyContentRepository repository = sl<IDailyContentRepository>();
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
          emptyStateWidget: const NoFavoriteYet(),
          listPadding: const EdgeInsets.only(
            bottom: AppSpacing.v16,
            left: AppSpacing.v16,
            right: AppSpacing.v16,
          ),

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
    CustomRichContentDialog.show(
      context,
      title: item.header,
      bodyText: item.content,
      source: item.attribution,
      backgroundIcon: SolarIconsBold.book,
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

  static const double _bgIconRight = -10;
  static const double _bgIconBottom = -20;
  static const double _bgIconSize = 150;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: customAppCardDecoration(context).copyWith(
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: _bgIconRight,
              bottom: _bgIconBottom,
              child: Icon(
                SolarIconsBold.book,
                size: _bgIconSize,
                color: context.color.textPrimary.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.v16),
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
                                item.header ?? item.shortContent,
                                style: AppTextStyles.font16W700(context).copyWith(color: context.color.textAccent),
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
                                      isAdded: false,
                                    );
                                  },
                                  isFav: true,
                                ),
                                const SizedBox(width: AppSpacing.v8),
                                CombinedShareCopyButton(
                                  onSharePressed: () async =>
                                      WidgetToImageHelper.shareWidget(
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
                                  const SizedBox(width: AppSpacing.v8),
                                  TextButton(
                                    onPressed: () {
                                      DailyContentExplanationDialog.show(
                                        context,
                                        explanation: item.explanation!,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.v8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      AppStrings.explanation,
                                      style: AppTextStyles.font14W700(context).copyWith(color: context.color.textAccent),
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
                  const SizedBox(height: AppSpacing.v8),
                  Text(
                    item.content,
                    style: AppTextStyles.font16W500(context).copyWith(color: context.color.textPrimary).copyWith(height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  if (item.attribution != null) ...[
                    const SizedBox(height: AppSpacing.v8),
                    const CustomAppDivider(),
                    const SizedBox(height: AppSpacing.v8),
                    Text(
                      item.attribution!,
                      style: AppTextStyles.font14W500(context).copyWith(color: context.color.textAccent),
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
