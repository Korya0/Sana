import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:sana/features/home/presentation/widgets/circular_category_grid_section.dart';
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
          return const SizedBox.shrink();
        }
        return const _FeaturesSkeletonLoader();
      },
    );
  }
}

class _FeaturesLoadedSection extends StatelessWidget {
  const _FeaturesLoadedSection({required this.state});
  final FeaturesListLoaded state;

  @override
  Widget build(BuildContext context) {
    final features = state.features.map((feature) {
      final isRestricted =
          kIsWeb &&
          (/* feature.route == AppRoutes.qibla || */
              feature.route == AppRoutes.salatAlaNabi);

      return CategoryItem(
        id: feature.id,
        title: feature.title,
        icon: feature.icon,
        route: feature.route,
        extra: feature.extra,
        isRestricted: isRestricted,
        isComingSoon: feature.isComingSoon,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Skeleton.keep(
          child: CategorySectionHeader(
            title: AppStrings.features,
          ),
        ),
        const SizedBox(height: AppSpacing.v12),
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
        CategoryItem(
          id: '1',
          title: AppStrings.quranKareem,
          icon: Icons.book,
          route: '',
        ),
        CategoryItem(
          id: '2',
          title: AppStrings.salawat,
          icon: Icons.mosque,
          route: '',
        ),
        CategoryItem(
          id: '3',
          title: AppStrings.teachPrayer,
          icon: Icons.book_online,
          route: '',
        ),
        CategoryItem(
          id: '4',
          title: AppStrings.qibla,
          icon: Icons.explore,
          route: '',
        ),
      ],
    );

    return const Skeletonizer(
      child: _FeaturesLoadedSection(state: dummyState),
    );
  }
}
