import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

extension TasbeehItemListExtensions on List<TasbeehItemEntity> {
  // Finds item
  TasbeehItemEntity? byId(String id) {
    for (final item in this) {
      if (item.id == id) return item;
    }
    return null;
  }
}
