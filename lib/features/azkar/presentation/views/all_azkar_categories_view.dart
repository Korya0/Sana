import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/animated_sliver_list.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_categories_cubit.dart';
import 'package:solar_icons/solar_icons.dart';

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
              if (state is AzkarCategoriesLoaded)
                AnimatedSliverList<AzkarCategoryModel>(
                  items: state.azkarCategories,
                  itemBuilder: (context, category, index) =>
                      _buildAzkarCategoryCard(context, category),
                )
              else if (state is AzkarCategoriesError)
                SliverFillRemaining(
                  child: AppErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<AzkarCategoriesCubit>().loadAzkar(),
                  ),
                )
              else
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAzkarCategoryCard(
    BuildContext context,
    AzkarCategoryModel category,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          // No incrementUsage
          await context.pushNamed(
            AppRoutes.azkar,
            pathParameters: {AppRoutes.categoryIdKey: category.id},
            extra: category,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.textWhite.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: Icon(category.icon, color: AppColors.gold, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.category,
                      style: AppTextStyles.font16W600White(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category.array.length} ${AppStrings.zkr}',
                      style: AppTextStyles.font12W500Grey(context),
                    ),
                  ],
                ),
              ),
              Icon(
                SolarIconsBold.altArrowLeft,
                color: AppColors.gold.withValues(alpha: 0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
