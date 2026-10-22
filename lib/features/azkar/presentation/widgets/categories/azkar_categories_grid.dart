import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_navigator.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/slivers/app_sliver_grid.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_category_card.dart';

class AzkarCategoriesGrid extends StatelessWidget {
  const AzkarCategoriesGrid({required this.categories, super.key});

  final List<CategoryEntity> categories;

  static const List<int> _orderedIds = [
    2,
    3,
    5,
    4,
    1,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
  ];

  @override
  Widget build(BuildContext context) {
    int resolveRank(int id) {
      final index = _orderedIds.indexOf(id);
      return index == -1 ? _orderedIds.length : index;
    }

    final ordered = [...categories]
      ..sort((a, b) => resolveRank(a.id).compareTo(resolveRank(b.id)));

    return SliverMainAxisGroup(
      slivers: [
        // Header
        const SliverToBoxAdapter(
          child: _CategoryHeaderWidget(title: AppStrings.azkarHeader),
        ),
        SliverToBoxAdapter(child: AppGap.h(AppSize.p12)),

        // Grid
        AppSliverGrid.extent(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
          maxCrossAxisExtent: AppSize.categoryTileMaxExtent,
          mainAxisSpacing: AppSize.p4,
          crossAxisSpacing: AppSize.p8,
          childAspectRatio: AppConstants.azkarCategoryTileAspectRatio,
          itemCount: ordered.length,
          itemBuilder: (context, index) {
            final category = ordered[index];
            final title = _cleanTitle(category.title);
            return AzkarCategoryCard(
              categoryId: category.id,
              title: title,
              onTap: () => AppNavigator.pushNamed(
                context,
                AppRoutes.azkarCategoryPath,
                pathParameters: {
                  AppRoutes.categoryIdParam: '${category.id}',
                },
                extra: category.title,
              ),
            );
          },
        ),
        SliverToBoxAdapter(child: AppGap.h(AppSize.p32)),
      ],
    );
  }

  String _cleanTitle(String title) =>
      title.startsWith(
        AppStrings.azkarTitlePrefix,
      )
      ? title.substring(AppStrings.azkarTitlePrefix.length)
      : title;
}

class _CategoryHeaderWidget extends StatelessWidget {
  const _CategoryHeaderWidget({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
    child: Row(
      children: [
        // Accent bar
        Container(
          width: AppSize.w4,
          height: AppSize.h18,
          decoration: BoxDecoration(
            color: context.color.primary,
            borderRadius: BorderRadius.circular(AppSize.r4),
          ),
        ),
        AppGap.w(AppSize.p8),

        // Title
        Expanded(
          child: Text(
            title,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16W700Primary(context),
          ),
        ),
      ],
    ),
  );
}
