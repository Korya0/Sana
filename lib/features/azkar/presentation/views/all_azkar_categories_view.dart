import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_ui_helpers.dart';

class AllAzkarCategoriesView extends StatelessWidget {
  const AllAzkarCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              const CommonSliverAppBar(title: AppStrings.allAzkar),
              ...switch (state) {
                AzkarCategoriesInitial() || AzkarCategoriesLoading() => [
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                AzkarCategoriesLoaded(:final azkarCategories) => [
                    AnimatedSliverList<AzkarCategoryModel>(
                      dataList: azkarCategories,
                      keyFinder: (category, index) =>
                          ValueKey('azkar_category_${category.id}_$index'),
                      itemContentBuilder: (context, category, index) =>
                          _AzkarCategoryCard(category: category),
                    ),
                  ],
                AzkarCategoriesError(:final message) => [
                    SliverFillRemaining(
                      child: AppErrorView(
                        message: message,
                        onRetry: () =>
                            context.read<AzkarCategoriesCubit>().loadAzkar(),
                      ),
                    ),
                  ],
              },
            ],
          );
        },
      ),
    );
  }
}

class _AzkarCategoryCard extends StatelessWidget {
  const _AzkarCategoryCard({required this.category});
  final AzkarCategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await context.pushNamed(
            AppRoutes.azkar,
            pathParameters: {AppRoutes.categoryIdKey: category.id},
            extra: category,
          );
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.v16),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
            border: Border.all(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.v12),
                child: Icon(
                  AzkarUIHelpers.getCategoryIcon(category.id),
                  color: AppColors.iconAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.v16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.category,
                      style: AppTextStyles.font16W700White(context),
                    ),
                    const SizedBox(height: AppSpacing.v4),
                    Text(
                      '${category.array.length} ${AppStrings.zkr}',
                      style: AppTextStyles.font12W500Grey(context),
                    ),
                  ],
                ),
              ),
              AppArrowIcon(
                color: AppColors.primary.withValues(alpha: 0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


