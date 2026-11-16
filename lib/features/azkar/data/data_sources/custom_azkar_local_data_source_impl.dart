import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/versioned_list_store.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';

class CustomAzkarLocalDataSourceImpl
    extends VersionedListStore<CustomCategoryModel>
    implements CustomAzkarLocalDataSource {
  // Creates data source
  CustomAzkarLocalDataSourceImpl(super.storage, super.logger)
    : super(
        storageKey: AppStorageKeys.customAzkar,
        unreadableKey: AppStorageKeys.customAzkarUnreadable,
        versionKey: azkarStorageVersionKey,
        itemsKey: azkarStorageItemsKey,
        schemaVersion: currentCustomAzkarSchemaVersion,
        logScope: 'CustomAzkarLocalDataSource',
        itemLabel: 'category',
      );

  // Loads categories
  @override
  Future<List<CustomCategoryModel>> getCustomCategories() => loadItems();

  // Saves category
  @override
  Future<void> saveCustomCategory(CustomCategoryModel category) =>
      saveItem(category);

  // Deletes category
  @override
  Future<void> deleteCustomCategory(String id) => deleteItem(id);

  // Finds category
  @override
  Future<CustomCategoryModel?> getCustomCategoryById(String id) async {
    final categories = await loadItems();
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  // Maps model
  @override
  CustomCategoryModel fromJson(Map<String, dynamic> json) =>
      CustomCategoryModel.fromJson(json);

  // Encodes model
  @override
  Map<String, dynamic> toJson(CustomCategoryModel item) => item.toJson();

  // Returns id
  @override
  String idOf(CustomCategoryModel item) => item.id;
}
