import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_categories_cubit.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/widgets/features_list_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeAzkarCategorySection extends StatelessWidget {
  const HomeAzkarCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
      builder: (context, state) {
        if (state is AzkarCategoriesLoaded) {
          return _AzkarLoadedSection(state: state);
        } else if (state is AzkarCategoriesError) {
          return const SizedBox.shrink();
        }
        return const _AzkarSkeletonLoader();
      },
    );
  }
}

class _AzkarLoadedSection extends StatelessWidget {
  const _AzkarLoadedSection({required this.state});
  final AzkarCategoriesLoaded state;

  @override
  Widget build(BuildContext context) {
    final azkarFeatures = state.azkarCategories
        .map(
          (category) => CategoryItem(
            id: category.id,
            title: category.category,
            icon: category.icon,
            route: AppRoutes.azkar,
            onTap: (context) async {
              // No usage tracking
              await context.pushNamed(
                AppRoutes.azkar,
                pathParameters: {AppRoutes.categoryIdKey: category.id},
                extra: category,
              );
            },
          ),
        )
        .toList();

    return CategoryListSection(
      features: azkarFeatures.take(12).toList(),
      isGrid: true,
      title: AppStrings.azkarHeader,
      headerChild: AppAnimations.pressScale(
        Text(
          AppStrings.showMore,
          style: AppTextStyles.font16W700Gold(context).copyWith(fontSize: 14),
        ),
        onTap: () => context.pushNamed(AppRoutes.allAzkar),
      ),
    );
  }
}

class _AzkarSkeletonLoader extends StatelessWidget {
  const _AzkarSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CategoryListSection(
        features: _buildSkeletonFeatures(),
        isGrid: true,
        title: AppStrings.azkarHeader,
      ),
    );
  }

  List<CategoryItem> _buildSkeletonFeatures() {
    return List.generate(
      8,
      (index) => CategoryItem(
        id: index.toString(),
        title: AppStrings.azkarHeader,
        icon: Icons.abc,
        route: AppRoutes.azkar,
        onTap: (context) async {},
      ),
    );
  }
}
