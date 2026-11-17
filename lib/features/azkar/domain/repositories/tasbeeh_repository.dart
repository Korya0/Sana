import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

abstract interface class TasbeehRepository {
  // Loads items
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems();

  // Saves item
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item);

  // Deletes item
  Future<Result<void>> deleteTasbeehItem(String id);
}
