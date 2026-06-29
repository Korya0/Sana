import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/views/azkar_details_loader_view.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';

final List<RouteBase> azkarRoutes = [
  GoRoute(
    path: AppRoutes.azkar,
    name: AppRoutes.azkar,
    pageBuilder: (context, state) {
      final categoryId = state.pathParameters[AppRoutes.categoryIdKey];
      final extra = state.extra;

      Widget child;
      if (extra is AzkarCategoryModel) {
        child = AzkarListView(category: extra);
      } else {
        child = AzkarDetailsLoaderView(categoryId: categoryId ?? '');
      }

      return AppTransitions.slideFromRight(
        context: context,
        state: state,
        child: child,
      );
    },
  ),
];
