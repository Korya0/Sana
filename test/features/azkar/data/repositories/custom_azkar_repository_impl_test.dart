import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';
import 'package:sana/features/azkar/data/repositories/custom_azkar_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

void main() {
  group('CustomAzkarRepositoryImpl', () {
    test('maps stored models to entities', () async {
      final repository = CustomAzkarRepositoryImpl(
        _FakeDataSource(
          categories: const [
            CustomCategoryModel(id: 'custom_1', name: 'قسمي', azkar: []),
          ],
        ),
        const _SilentLogger(),
      );

      final result = await repository.getCustomCategories();

      final success = result as Success<List<CustomCategoryEntity>>;
      expect(success.data.single.id, 'custom_1');
    });

    test('reports a load error when reading fails', () async {
      final repository = CustomAzkarRepositoryImpl(
        _FakeDataSource(failOn: 'get'),
        const _SilentLogger(),
      );

      final result = await repository.getCustomCategories();

      expect(_messageOf(result), AppStrings.azkarLoadError);
    });

    test('reports an azkar save error when writing fails', () async {
      final repository = CustomAzkarRepositoryImpl(
        _FakeDataSource(failOn: 'save'),
        const _SilentLogger(),
      );

      final result = await repository.saveCustomCategory(
        const CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
      );

      expect(_messageOf(result), AppStrings.azkarSaveError);
    });

    test('reports an azkar delete error when deleting fails', () async {
      final repository = CustomAzkarRepositoryImpl(
        _FakeDataSource(failOn: 'delete'),
        const _SilentLogger(),
      );

      final result = await repository.deleteCustomCategory('custom_1');

      expect(_messageOf(result), AppStrings.azkarDeleteError);
    });

    test('reports a load error when lookup by id fails', () async {
      final repository = CustomAzkarRepositoryImpl(
        _FakeDataSource(failOn: 'byId'),
        const _SilentLogger(),
      );

      final result = await repository.getCustomCategoryById('custom_1');

      expect(_messageOf(result), AppStrings.azkarLoadError);
    });
  });
}

String _messageOf(Result<Object?> result) =>
    (result as FailureResult<Object?>).failure.message;

class _FakeDataSource implements CustomAzkarLocalDataSource {
  _FakeDataSource({this.categories = const [], this.failOn});

  final List<CustomCategoryModel> categories;
  final String? failOn;

  @override
  Future<List<CustomCategoryModel>> getCustomCategories() async {
    if (failOn == 'get') throw StateError('read failed');
    return categories;
  }

  @override
  Future<void> saveCustomCategory(CustomCategoryModel category) async {
    if (failOn == 'save') throw StateError('write failed');
  }

  @override
  Future<void> deleteCustomCategory(String id) async {
    if (failOn == 'delete') throw StateError('delete failed');
  }

  @override
  Future<CustomCategoryModel?> getCustomCategoryById(String id) async {
    if (failOn == 'byId') throw StateError('lookup failed');
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }
}

class _SilentLogger extends AppLogger {
  const _SilentLogger();

  @override
  void warning(String message) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}
