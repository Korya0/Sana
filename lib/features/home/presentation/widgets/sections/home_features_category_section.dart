import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/controller/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/features_list_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeFeaturesCategorySection extends StatelessWidget {
  const HomeFeaturesCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturesListCubit, FeaturesListState>(
      builder: (context, state) {
        if (state is FeaturesListLoaded) {
          return _FeaturesLoadedSection(state: state);
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
    // [Web Support] فلترة الميزات غير المدعومة على الويب
    // [Web Support] عرض الميزات غير المدعومة على الويب مع بانر "غير متاح"
    final featuresWithTap = state.features.map((feature) {
      final isRestricted =
          kIsWeb &&
          (feature.route == AppRoutes.qibla ||
              feature.route == AppRoutes.salatAlaNabi 
              || feature.route == AppRoutes.hadithSearch
              );

      return CategoryItem(
        id: feature.id,
        title: feature.title,
        icon: feature.icon,
        route: feature.route,
        extra: feature.extra,
        isRestricted: isRestricted,
        onTap: (context) async {
          if (isRestricted) {
            var message = AppStrings.webNotSupported;
            if (feature.route == AppRoutes.qibla) {
              message = AppStrings.qiblaWebNotSupported;
            } else if (feature.route == AppRoutes.salatAlaNabi) {
              message = AppStrings.salatAlaNabiWebNotSupported;
            } else if (feature.route == AppRoutes.hadithSearch) {
              message = AppStrings.hadithSearchWebNotSupported;
            }

            AppToast.show(context, message);
          } else {
            await context.pushNamed(feature.route, extra: feature.extra);
          }
        },
      );
    }).toList();

    return CategoryListSection(
      features: featuresWithTap,
      // usageKey removed
      title: AppStrings.features,
    );
  }
}

class _FeaturesSkeletonLoader extends StatelessWidget {
  const _FeaturesSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CategoryListSection(
        features: _buildSkeletonFeatures(),
        // usageKey removed
        title: AppStrings.features,
      ),
    );
  }

  List<CategoryItem> _buildSkeletonFeatures() {
    return List.generate(
      3,
      (index) => CategoryItem(
        id: index.toString(),
        title: AppStrings.feature,
        icon: Icons.abc,
        route: '',
        onTap: (context) async {},
      ),
    );
  }
}
