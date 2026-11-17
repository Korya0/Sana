import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

// Finds an item by id
extension TasbeehItemListExtensions on List<TasbeehItemEntity> {
  TasbeehItemEntity? byId(String id) {
    for (final item in this) {
      if (item.id == id) return item;
    }
    return null;
  }
}
