import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/features/azkar/data/constants/tasbeeh_constants.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/versioned_list_store.dart';
import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';

class TasbeehLocalDataSourceImpl extends VersionedListStore<TasbeehItemModel>
    implements TasbeehLocalDataSource {
  // Creates data source
  TasbeehLocalDataSourceImpl(super.storage, super.logger)
    : super(
        storageKey: AppStorageKeys.tasbeehItems,
        unreadableKey: AppStorageKeys.tasbeehItemsUnreadable,
        versionKey: tasbeehStorageVersionKey,
        itemsKey: tasbeehStorageItemsKey,
        schemaVersion: currentTasbeehSchemaVersion,
        logScope: 'TasbeehLocalDataSource',
        itemLabel: 'item',
      );

  // Loads items
  @override
  Future<List<TasbeehItemModel>> getTasbeehItems() => loadItems();

  // Saves item
  @override
  Future<void> saveTasbeehItem(TasbeehItemModel item) => saveItem(item);

  // Deletes item
  @override
  Future<void> deleteTasbeehItem(String id) => deleteItem(id);

  // Maps model
  @override
  TasbeehItemModel fromJson(Map<String, dynamic> json) =>
      TasbeehItemModel.fromJson(json);

  // Encodes model
  @override
  Map<String, dynamic> toJson(TasbeehItemModel item) => item.toJson();

  // Returns id
  @override
  String idOf(TasbeehItemModel item) => item.id;
}
