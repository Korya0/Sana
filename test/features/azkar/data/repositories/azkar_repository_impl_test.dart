import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/custom_category_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

void main() {
  group('AzkarRepositoryImpl', () {
    test('maps local categories to entities', () async {
      final repository = AzkarRepositoryImpl(
        _FakeAzkarDataSource(
          categories: const [
            AzkarCategoryModel(
              key: 'morning',
              title: 'أذكار الصباح',
              cardTitle: 'الصباح',
            ),
          ],
        ),
        const _SilentLogger(),
        _FakeCustomDataSource(),
      );

      final result = await repository.getCategories();

      final success = result as Success<List<AzkarCategoryEntity>>;
      expect(success.data.single.key, 'morning');
      expect(success.data.single.title, 'أذكار الصباح');
    });

    test('prefers a stored custom override over the bundled azkar', () async {
      final local = _FakeAzkarDataSource(
        azkar: const [ZikrModel(id: 1, text: 'الأصل', count: 3)],
      );
      final repository = AzkarRepositoryImpl(
        local,
        const _SilentLogger(),
        _FakeCustomDataSource(
          category: const CustomCategoryModel(
            id: 'morning',
            name: 'اسم معدّل',
            azkar: [ZikrModel(id: 2, text: 'النسخة المعدّلة', count: 5)],
          ),
        ),
      );

      final result = await repository.getZikrsByCategory('morning');

      final success = result as Success<List<ZikrEntity>>;
      expect(success.data.single.text, 'النسخة المعدّلة');
      expect(local.azkarCalls, 0);
    });

    test('falls back to the bundled azkar when no override exists', () async {
      final repository = AzkarRepositoryImpl(
        _FakeAzkarDataSource(
          azkar: const [ZikrModel(id: 1, text: 'الأصل', count: 3)],
        ),
        const _SilentLogger(),
        _FakeCustomDataSource(),
      );

      final result = await repository.getZikrsByCategory('morning');

      final success = result as Success<List<ZikrEntity>>;
      expect(success.data.single.text, 'الأصل');
    });

    test('reports a load error when categories fail', () async {
      final repository = AzkarRepositoryImpl(
        _FakeAzkarDataSource(fail: true),
        const _SilentLogger(),
        _FakeCustomDataSource(),
      );

      final result = await repository.getCategories();

      expect(_messageOf(result), AppStrings.azkarLoadError);
    });

    test('reports a load error when azkar fail', () async {
      final repository = AzkarRepositoryImpl(
        _FakeAzkarDataSource(fail: true),
        const _SilentLogger(),
        _FakeCustomDataSource(),
      );

      final result = await repository.getZikrsByCategory('morning');

      expect(_messageOf(result), AppStrings.azkarLoadError);
    });
  });
}

String _messageOf(Result<Object?> result) =>
    (result as FailureResult<Object?>).failure.message;

class _FakeAzkarDataSource implements AzkarLocalDataSource {
  _FakeAzkarDataSource({
    this.categories = const [],
    this.azkar = const [],
    this.fail = false,
  });

  final List<AzkarCategoryModel> categories;
  final List<ZikrModel> azkar;
  final bool fail;
  int azkarCalls = 0;

  @override
  Future<List<AzkarCategoryModel>> getCategories() async {
    if (fail) throw StateError('categories failed');
    return categories;
  }

  @override
  Future<List<ZikrModel>> getZikrsByCategory(String categoryKey) async {
    if (fail) throw StateError('azkar failed');
    azkarCalls++;
    return azkar;
  }
}

class _FakeCustomDataSource implements CustomCategoryLocalDataSource {
  _FakeCustomDataSource({this.category});

  final CustomCategoryModel? category;

  @override
  Future<List<CustomCategoryModel>> getCustomCategories() async =>
      category == null ? const [] : [category!];

  @override
  Future<CustomCategoryModel?> getCustomCategoryById(String id) async =>
      category;

  @override
  Future<void> saveCustomCategory(CustomCategoryModel category) async {}

  @override
  Future<void> deleteCustomCategory(String id) async {}
}

class _SilentLogger extends AppLogger {
  const _SilentLogger();

  @override
  void warning(String message) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}
