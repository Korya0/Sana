import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/category/features_list_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeaturesCategoryBlocBuilder extends StatelessWidget {
  const FeaturesCategoryBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturesListCubit, FeaturesListState>(
      builder: (context, state) {
        if (state is FeaturesListLoaded) {
          return _PrayerFeaturesLoadedSection(state: state);
        } else if (state is FeaturesListError) {
          return const SizedBox.shrink();
        }
        return const _PrayerFeaturesSkeletonLoader();
      },
    );
  }
}

class _PrayerFeaturesLoadedSection extends StatelessWidget {
  final FeaturesListLoaded state;

  const _PrayerFeaturesLoadedSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final featuresWithTap = state.features
        .map(
          (feature) => CategoryItem(
            id: feature.id,
            title: feature.title,
            icon: feature.icon,
            route: feature.route,
            extra: feature.extra,
            onTap: (context) async {
              // No usage tracking
              await context.pushNamed(feature.route, extra: feature.extra);
            },
          ),
        )
        .toList();

    return CategoryListSection(
      features: featuresWithTap,
      // usageKey removed
      title: 'ميزات',
    );
  }
}

class _PrayerFeaturesSkeletonLoader extends StatelessWidget {
  const _PrayerFeaturesSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CategoryListSection(
        features: _buildSkeletonFeatures(),
        // usageKey removed
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
