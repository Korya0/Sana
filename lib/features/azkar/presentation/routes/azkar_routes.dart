import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/views/all_azkar_categories_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_details_loader_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';

class AzkarRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.azkar,
      name: AppRoutes.azkar,
      pageBuilder: (context, state) {
        final categoryId = state.pathParameters[AppRoutes.categoryIdKey];
        final extra = state.extra;

        if (extra is AzkarCategoryModel) {
          return AppTransitions.slideFromRight(
            context: context,
            state: state,
            child: AzkarListView(category: extra),
          );
        }

        return AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: AzkarDetailsLoaderView(categoryId: categoryId ?? ''),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.allAzkar,
      name: AppRoutes.allAzkar,
      pageBuilder: (context, state) => AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: BlocProvider(
          create: (context) => sl<AzkarCategoriesCubit>(),
          child: const AllAzkarCategoriesView(),
        ),
      ),
    ),
  ];
}
