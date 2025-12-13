import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_state.dart';
import 'package:sana/features/home/presentation/widgets/category/features_list_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeaturesCategoryBlocBuilder extends StatelessWidget {
  const FeaturesCategoryBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      SortableCategoryCubit<CategoryItem>,
      SortableCategoryState<CategoryItem>
    >(
      builder: (context, state) {
        if (state is SortableFeaturesLoaded<CategoryItem>) {
          return _PrayerFeaturesLoadedSection(state: state);
        } else if (state is SortableCategoryError<CategoryItem>) {
          return const SizedBox.shrink();
        }
        return const _PrayerFeaturesSkeletonLoader();
      },
    );
  }
}

class _PrayerFeaturesLoadedSection extends StatelessWidget {
  final SortableFeaturesLoaded<CategoryItem> state;

  const _PrayerFeaturesLoadedSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final featuresWithTap = state.items
        .map(
          (feature) => CategoryItem(
            id: feature.id,
            title: feature.title,
            icon: feature.icon,
            route: feature.route,
            extra: feature.extra,
            onTap: (context) async {
              context
                  .read<SortableCategoryCubit<CategoryItem>>()
                  .incrementUsage(feature.id);
              await context.pushNamed(feature.route, extra: feature.extra);
            },
          ),
        )
        .toList();

    return CategoryListSection(
      features: featuresWithTap,
      usageKey: PrefKeys.allFeaturesUsage,
      isGrid: false,
      title: 'ميزات',
    );
  }
}

class _PrayerFeaturesSkeletonLoader extends StatelessWidget {
  const _PrayerFeaturesSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: CategoryListSection(
        features: _buildSkeletonFeatures(),
        usageKey: PrefKeys.allFeaturesUsage,
        isGrid: false,
        title: 'ميزات',
      ),
    );
  }

  List<CategoryItem> _buildSkeletonFeatures() {
    return List.generate(
      3,
      (index) => CategoryItem(
        id: index.toString(),
        title: 'ميزة',
        icon: Icons.abc,
        route: '',
        onTap: (context) async {},
      ),
    );
  }
}
