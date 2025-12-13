import 'package:sana/features/azkar/domain/entities/azkar_category.dart';

abstract class AzkarRepository {
  Future<List<AzkarCategory>> getAllCategories();
}
