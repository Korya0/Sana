import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

class AzkarLocalDataSourceImpl implements AzkarLocalDataSource {
  AzkarLocalDataSourceImpl();

  @override
  Future<void> ensureDatabaseReady() async {
    try {
      final versionJsonStr = await rootBundle.loadString(
        AppAssets.azkarVersion,
      );
      final versionData = json.decode(versionJsonStr) as Map<String, dynamic>;
      final assetVersion = versionData[AzkarConstants.versionMapKey] as int;

      final metadataBox = await Hive.openBox<int>(
        AzkarConstants.metadataBoxName,
      );
      final currentVersion =
          metadataBox.get(AzkarConstants.versionKey, defaultValue: 0) ?? 0;

      if (currentVersion < assetVersion) {
        AppLogger.info(
          'AzkarDatabase: Updating from $currentVersion to $assetVersion',
        );
        await _loadAndSaveCategories();

        // Delete existing category-specific boxes from disk so they will be
        // reloaded lazily on demand when the user visits them.
        final categories = await getCategories();
        for (final category in categories) {
          await Hive.deleteBoxFromDisk(
            '${AzkarConstants.azkarCategoryBoxPrefix}${category.id}',
          );
        }

        await metadataBox.put(AzkarConstants.versionKey, assetVersion);
        AppLogger.info('AzkarDatabase: Update complete');
      }
    } on Object catch (e, stack) {
      await AppLogger.reportToFirebase(
        'AzkarDatabase: Error ensuring database ready',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<void> _loadAndSaveCategories() async {
    try {
      final categoriesJsonStr = await rootBundle.loadString(
        AppAssets.azkarCategoriesJson,
      );
      final data = json.decode(categoriesJsonStr) as List<dynamic>;
      final box = await Hive.openBox<String>(AzkarConstants.categoriesBoxName);
      await box.clear();

      for (final item in data) {
        try {
          final model = CategoryModel.fromJson(item as Map<String, dynamic>);
          await box.put(model.id, json.encode(item));
        } on Object catch (_) {
          await AppLogger.warn('AzkarDatabase: Skipping invalid category item');
        }
      }
    } on Object catch (e, stack) {
      await AppLogger.reportToFirebase(
        'AzkarDatabase: Error loading categories.json',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<void> _loadAndSaveAzkar(int categoryId) async {
    try {
      final azkarJsonStr = await rootBundle.loadString(
        AppAssets.azkarCategoryJson(categoryId),
      );
      final data = json.decode(azkarJsonStr) as List<dynamic>;
      final box = await Hive.openBox<String>(
        '${AzkarConstants.azkarCategoryBoxPrefix}$categoryId',
      );
      await box.clear();

      for (final item in data) {
        try {
          final model = ZikrModel.fromJson(item as Map<String, dynamic>);
          await box.put(model.id, json.encode(item));
        } on Object catch (_) {
          await AppLogger.warn(
            'AzkarDatabase: Skipping invalid zikr item in category $categoryId',
          );
        }
      }
    } on Object catch (_) {
      await AppLogger.warn(
        'AzkarDatabase: Could not load azkar for category $categoryId',
      );
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final box = await Hive.openBox<String>(AzkarConstants.categoriesBoxName);
    final categories = <CategoryModel>[];
    for (final key in box.keys) {
      final itemStr = box.get(key)!;
      categories.add(
        CategoryModel.fromJson(json.decode(itemStr) as Map<String, dynamic>),
      );
    }
    return categories;
  }

  @override
  Future<List<ZikrModel>> getAzkarByCategory(int categoryId) async {
    final box = await Hive.openBox<String>(
      '${AzkarConstants.azkarCategoryBoxPrefix}$categoryId',
    );
    if (box.isEmpty) {
      await _loadAndSaveAzkar(categoryId);
    }
    final azkar = <ZikrModel>[];
    for (final key in box.keys) {
      final itemStr = box.get(key)!;
      azkar.add(
        ZikrModel.fromJson(json.decode(itemStr) as Map<String, dynamic>),
      );
    }
    return azkar;
  }
}
