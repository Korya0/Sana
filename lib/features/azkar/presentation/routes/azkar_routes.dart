import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/azkar/presentation/pages/azkar_list_view.dart';

final List<RouteBase> azkarRoutes = [
  GoRoute(
    path: AppRoutes.azkarList,
    name: AppRoutes.azkarList,
    pageBuilder: (context, state) {
      final categoryId =
          int.tryParse(state.pathParameters[AppRoutes.categoryIdKey] ?? '') ??
          0;
      final extraTitle = (state.extra as String?) ?? AppStrings.azkarHeader;
      return AppTransitions.fade(
        context: context,
        state: state,
        child: AzkarListView(
          categoryId: categoryId,
          categoryTitle: extraTitle,
        ),
      );
    },
  ),
];
