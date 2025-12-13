import 'package:sana/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  final AzkarLocalDataSource localDataSource;

  AzkarRepositoryImpl(this.localDataSource);

  @override
  Future<List<AzkarCategory>> getAllCategories() async {
    // Determine if we need to map or if covariance handles it.
    // The data source returns List<AzkarCategoryModel>.
    // AzkarCategoryModel extends AzkarCategory.
    // So logic should be fine.
    return localDataSource.getAllCategories();
  }
}
