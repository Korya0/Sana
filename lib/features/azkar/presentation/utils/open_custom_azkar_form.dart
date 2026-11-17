import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

class OpenCustomAzkarForm {
  const OpenCustomAzkarForm._();

  static Future<void> andReload(
    BuildContext context, {
    CustomCategoryEntity? category,
    required Future<void> Function() reload,
  }) async {
    final saved = await context.pushNamed<CustomCategoryEntity>(
      AppRoutes.customAzkarFormView,
      extra: category,
    );
    if (saved == null || !context.mounted) return;
    await reload();
  }
}
