import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart';
import 'package:sana/features/azkar/presentation/views/custom_azkar_list_view.dart';
import 'package:sana/features/azkar/presentation/views/custom_zikr_form_view.dart';
import 'package:sana/features/azkar/presentation/views/tasbeeh_view.dart';
import 'package:sana/features/azkar/presentation/views/zikr_list_view.dart';

// Standalone routes
final List<RouteBase> azkarTasbeehRoutes = [
  // Azkar reader
  GoRoute(
    path: AppRoutes.zikrListView,
    name: AppRoutes.zikrListView,
    builder: (context, state) {
      final categoryKey = state.pathParameters[AppRoutes.categoryParam] ?? '';
      final extra = state.extra;
      final categoryTitle = extra is String ? extra : AppStrings.azkarHeader;

      return ZikrListView(
        categoryKey: categoryKey,
        categoryTitle: categoryTitle,
      );
    },
  ),

  // Custom zikr form
  GoRoute(
    path: AppRoutes.zikrFormView,
    name: AppRoutes.zikrFormView,
    builder: (context, state) {
      final extra = state.extra;
      final initialCategory = extra is CustomCategoryEntity ? extra : null;
      return CustomZikrFormView(initialCategory: initialCategory);
    },
  ),

  // Custom azkar list
  GoRoute(
    path: AppRoutes.customAzkarView,
    name: AppRoutes.customAzkarView,
    builder: (context, state) => const CustomAzkarListView(),
  ),

  // Tasbeeh
  GoRoute(
    path: AppRoutes.tasbeehView,
    name: AppRoutes.tasbeehView,
    builder: (context, state) {
      final extra = state.extra;
      final selectedId = extra is String ? extra : null;
      return TasbeehView(initialSelectedId: selectedId);
    },
  ),
];

// Azkar tasbeeh tab
final RouteBase azkarTasbeehTabRoute = GoRoute(
  path: AppRoutes.adhkarView,
  name: AppRoutes.adhkarView,
  builder: (context, state) => const AzkarTasbeehHomeView(),
);
