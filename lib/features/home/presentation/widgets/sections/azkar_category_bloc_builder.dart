import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_state.dart';
import 'package:sana/features/home/presentation/widgets/category/features_list_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AzkarCategoryBlocBuilder extends StatelessWidget {
  const AzkarCategoryBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      SortableCategoryCubit<AzkarCategoryModel>,
      SortableCategoryState<AzkarCategoryModel>
    >(
      builder: (context, state) {
        if (state is SortableFeaturesLoaded<AzkarCategoryModel>) {
          return _AzkarLoadedSection(state: state);
        } else if (state is SortableCategoryError<AzkarCategoryModel>) {
          return const SizedBox.shrink();
        }
        return const _AzkarSkeletonLoader();
      },
    );
  }
}

class _AzkarLoadedSection extends StatelessWidget {
  final SortableFeaturesLoaded<AzkarCategoryModel> state;

  const _AzkarLoadedSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final azkarFeatures = state.items
        .map(
          (category) => CategoryItem(
            id: category.id.toString(),
            title: category.category,
            icon: category.icon,
            route: AppRoutes.azkar,
            onTap: (context) async {
              context
                  .read<SortableCategoryCubit<AzkarCategoryModel>>()
                  .incrementUsage(category.id.toString());
              await context.pushNamed(AppRoutes.azkar, extra: category);
            },
          ),
        )
        .toList();

    return CategoryListSection(
      features: azkarFeatures.take(12).toList(),
      usageKey: PrefKeys.azkarCategoryUsage,
      isGrid: true,
      title: 'ألاذكار',
      headerChild: GestureDetector(
        onTap: () => context.pushNamed(AppRoutes.allAzkar),
        child: Text(
          'عرض المزيد',
          style: AppTextStyles.font16W700Gold(context).copyWith(fontSize: 14),
        ),
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
        usageKey: PrefKeys.azkarCategoryUsage,
        isGrid: true,
        title: 'ألاذكار',
      ),
    );
  }

  List<CategoryItem> _buildSkeletonFeatures() {
    return List.generate(
      8,
      (index) => CategoryItem(
        id: index.toString(),
        title: 'ألاذكار',
        icon: Icons.abc,
        route: AppRoutes.azkar,
        onTap: (context) async {},
      ),
    );
  }
}
