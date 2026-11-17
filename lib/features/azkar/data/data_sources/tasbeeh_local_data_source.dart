import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';

abstract interface class TasbeehLocalDataSource {
  // Loads items
  Future<List<TasbeehItemModel>> getTasbeehItems();

  // Saves item
  Future<void> saveTasbeehItem(TasbeehItemModel item);

  // Deletes item
  Future<void> deleteTasbeehItem(String id);
}
