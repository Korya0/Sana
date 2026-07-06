import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/azkar/presentation/views/azkar_categories_screen.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_screen.dart';

final List<RouteBase> azkarRoutes = [
  GoRoute(
    path: AppRoutes.azkarCategories,
    name: AppRoutes.azkarCategories,
    pageBuilder: (context, state) => AppTransitions.fade(
      context: context,
      state: state,
      child: const AzkarCategoriesScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.azkarList,
    name: AppRoutes.azkarList,
    pageBuilder: (context, state) {
      final categoryId = int.tryParse(state.pathParameters[AppRoutes.categoryIdKey] ?? '') ?? 0;
      return AppTransitions.fade(
        context: context,
        state: state,
        child: AzkarListScreen(categoryId: categoryId),
      );
    },
  ),
];
