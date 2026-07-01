import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:sana/features/home/presentation/widgets/circular_category_grid_section.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeFeaturesCategorySection extends StatelessWidget {
  const HomeFeaturesCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturesListCubit, FeaturesListState>(
      builder: (context, state) {
        if (state is FeaturesListLoaded) {
          return _FeaturesLoadedSection(
            state: state,
          );
        } else if (state is FeaturesListError) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return const _FeaturesSkeletonLoader();
      },
    );
  }
}

class _FeaturesLoadedSection extends StatelessWidget {
  const _FeaturesLoadedSection({required this.state});
  final FeaturesListLoaded state;

  CategoryItem? _mapIdToCategory(String id) {
    switch (id) {
      case 'salawat':
        return const CategoryItem(
          id: 'salawat',
          title: AppStrings.salawat,
          icon: FlutterIslamicIcons.solidMohammad,
          route: AppRoutes.salatAlaNabi,
          isRestricted: kIsWeb,
        );
      case 'asma_ul_husna':
        return const CategoryItem(
          id: 'asma_ul_husna',
          title: AppStrings.asmaUlHusnaHome,
          icon: FlutterIslamicIcons.solidAllah,
          route: AppRoutes.asmaUlHusna,
        );
      case 'teaching_prayer':
        return const CategoryItem(
          id: 'teaching_prayer',
          title: AppStrings.teachPrayer,
          icon: SolarIconsBold.book2,
          route: AppRoutes.teachingPrayer,
        );
      case 'qibla':
        return const CategoryItem(
          id: 'qibla',
          title: AppStrings.qibla,
          icon: SolarIconsBold.compass,
          route: AppRoutes.qibla,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = state.features
        .map(_mapIdToCategory)
        .whereType<CategoryItem>()
        .toList();

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton.keep(
                child: CategorySectionHeader(
                  title: AppStrings.features,
                ),
              ),
              SizedBox(height: AppSpacing.v12),
            ],
          ),
        ),
        CircularCategoryGridSection(
          categories: features,
          title: AppStrings.features,
          onCategoryTap: (item) async {
            if (item.isComingSoon) {
              AppToast.show(context, AppStrings.comingSoon);
            } else if (item.isRestricted) {
              AppToast.show(
                context,
                AppStrings.webFeatureNotSupported(item.title),
                type: AppToastType.warning,
              );
            } else {
              await context.pushNamed(item.route, extra: item.extra);
            }
          },
        ),
      ],
    );
  }
}

class _FeaturesSkeletonLoader extends StatelessWidget {
  const _FeaturesSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    const dummyState = FeaturesListLoaded(
      [
        'salawat',
        'asma_ul_husna',
        'teaching_prayer',
        'qibla',
      ],
    );

    return const SliverSkeletonizer(
      child: _FeaturesLoadedSection(state: dummyState),
    );
  }
}
