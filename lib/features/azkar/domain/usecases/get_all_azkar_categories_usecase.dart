import 'package:sana/features/azkar/domain/entities/azkar_category.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class GetAllAzkarCategoriesUseCase {
  final AzkarRepository repository;

  GetAllAzkarCategoriesUseCase(this.repository);

  Future<List<AzkarCategory>> call() async {
    return await repository.getAllCategories();
  }
}
