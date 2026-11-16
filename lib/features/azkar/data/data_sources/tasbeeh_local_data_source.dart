import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';

abstract interface class TasbeehLocalDataSource {
  // Loads items
  Future<List<TasbeehItemModel>> getItems();

  // Saves item
  Future<void> saveItem(TasbeehItemModel item);

  // Deletes item
  Future<void> deleteItem(String id);
}
