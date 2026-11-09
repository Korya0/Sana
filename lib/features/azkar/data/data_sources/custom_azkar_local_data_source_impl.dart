import 'dart:convert';

import 'package:sana/core/services/local_storage/app_local_storage.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';

class CustomAzkarLocalDataSourceImpl implements CustomAzkarLocalDataSource {
  const CustomAzkarLocalDataSourceImpl(this._storage);

  final AppLocalStorage _storage;

  // Reads all custom categories from local storage
  @override
  Future<List<CustomCategoryModel>> getCustomCategories() async {
    final rawJson = _storage.read<String>(AppStorageKeys.customAzkar);
    if (rawJson == null || rawJson.trim().isEmpty) {
      return [];
    }

    final decoded = json.decode(rawJson) as List<dynamic>;
    return decoded
        .map((item) => CustomCategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Saves or updates a custom category in local storage
  @override
  Future<void> saveCustomCategory(CustomCategoryModel category) async {
    final currentList = await getCustomCategories();
    final index = currentList.indexWhere((item) => item.id == category.id);

    if (index >= 0) {
      currentList[index] = category;
    } else {
      currentList.insert(0, category);
    }

    final encoded = json.encode(
      currentList.map((item) => item.toJson()).toList(),
    );
    await _storage.write(AppStorageKeys.customAzkar, encoded);
  }

  // Deletes a custom category from local storage
  @override
  Future<void> deleteCustomCategory(String id) async {
    final currentList = await getCustomCategories();
    currentList.removeWhere((item) => item.id == id);

    final encoded = json.encode(
      currentList.map((item) => item.toJson()).toList(),
    );
    await _storage.write(AppStorageKeys.customAzkar, encoded);
  }

  // Finds a custom category by id
  @override
  Future<CustomCategoryModel?> getCustomCategoryById(String id) async {
    final currentList = await getCustomCategories();
    try {
      return currentList.firstWhere((item) => item.id == id);
    } on StateError {
      return null;
    }
  }
}

