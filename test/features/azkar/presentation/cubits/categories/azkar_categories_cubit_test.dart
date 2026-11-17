import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';

void main() {
  group('AzkarCategoriesCubit', () {
    test(
      'keeps the original name for a modified built-in category',
      () async {
        final azkarRepository = _FakeAzkarRepository(
          categories: const [
            AzkarCategoryEntity(
              key: 'morning',
              title: 'أذكار الصباح',
              cardTitle: 'الصباح',
            ),
          ],
        );
        final customRepository = _FakeCustomCategoryRepository(
          categories: const [
            CustomCategoryEntity(
              id: 'morning',
              name: 'اسم معدّل',
              azkar: [],
            ),
          ],
        );
        final cubit = AzkarCategoriesCubit(
          GetAzkarCategoriesUseCase(azkarRepository),
          GetCustomCategoriesUseCase(customRepository),
          GetZikrsByCategoryUseCase(_FakeAzkarRepository(categories: const [])),
        );
        await cubit.loadCategories();

        final state = cubit.state as AzkarCategoriesLoaded;
        final category = state.categories.single;
        expect(category.key, 'morning');
        expect(category.title, 'أذكار الصباح');
        expect(category.cardTitle, 'الصباح');
        expect(category.isCustom, isFalse);
        expect(category.isModified, isTrue);
      },
    );

    test('places user-created categories before the built-in ones', () async {
      final cubit = AzkarCategoriesCubit(
        GetAzkarCategoriesUseCase(
          _FakeAzkarRepository(
            categories: const [
              AzkarCategoryEntity(
                key: 'morning',
                title: 'أذكار الصباح',
                cardTitle: 'الصباح',
              ),
            ],
          ),
        ),
        GetCustomCategoriesUseCase(
          _FakeCustomCategoryRepository(
            categories: const [
              CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
            ],
          ),
        ),
        GetZikrsByCategoryUseCase(_FakeAzkarRepository(categories: const [])),
      );
      await cubit.loadCategories();

      final state = cubit.state as AzkarCategoriesLoaded;
      expect(state.categories.map((c) => c.key), ['custom_1', 'morning']);
      expect(state.categories.first.isCustom, isTrue);
    });

    test('emits empty when there are no categories', () async {
      final cubit = AzkarCategoriesCubit(
        GetAzkarCategoriesUseCase(_FakeAzkarRepository(categories: const [])),
        GetCustomCategoriesUseCase(
          _FakeCustomCategoryRepository(categories: const []),
        ),
        GetZikrsByCategoryUseCase(_FakeAzkarRepository(categories: const [])),
      );
      await cubit.loadCategories();

      expect(cubit.state, isA<AzkarCategoriesEmpty>());
    });

    test('emits an error when the built-in categories fail', () async {
      final cubit = AzkarCategoriesCubit(
        GetAzkarCategoriesUseCase(
          _FakeAzkarRepository(categories: const [], failure: true),
        ),
        GetCustomCategoriesUseCase(
          _FakeCustomCategoryRepository(categories: const []),
        ),
        GetZikrsByCategoryUseCase(_FakeAzkarRepository(categories: const [])),
      );
      await cubit.loadCategories();

      expect((cubit.state as AzkarCategoriesError).message, 'تعذّر التحميل');
    });

    test('keeps the built-ins when custom categories fail', () async {
      final cubit = AzkarCategoriesCubit(
        GetAzkarCategoriesUseCase(
          _FakeAzkarRepository(
            categories: const [
              AzkarCategoryEntity(
                key: 'morning',
                title: 'أذكار الصباح',
                cardTitle: 'الصباح',
              ),
            ],
          ),
        ),
        GetCustomCategoriesUseCase(
          _FakeCustomCategoryRepository(categories: const [], failure: true),
        ),
        GetZikrsByCategoryUseCase(_FakeAzkarRepository(categories: const [])),
      );
      await cubit.loadCategories();

      final state = cubit.state as AzkarCategoriesLoaded;
      expect(state.categories.single.key, 'morning');
    });

    test('loads azkar for a category through the use case', () async {
      final repository = _FakeAzkarRepository(categories: const []);
      repository.azkarByKey['morning'] = const [
        ZikrEntity(id: 1, text: 'ذكر', count: 3),
      ];
      final cubit = AzkarCategoriesCubit(
        GetAzkarCategoriesUseCase(repository),
        GetCustomCategoriesUseCase(
          _FakeCustomCategoryRepository(categories: const []),
        ),
        GetZikrsByCategoryUseCase(repository),
      );

      final result = await cubit.getAzkarForCategory('morning');

      expect(result, isA<Success<List<ZikrEntity>>>());
      expect((result as Success).data.single.id, 1);
    });
  });
}

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository({required this.categories, this.failure = false});

  final List<AzkarCategoryEntity> categories;
  final bool failure;
  final Map<String, List<ZikrEntity>> azkarByKey = {};

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async {
    if (failure) {
      return const Result.failure(CacheFailure(message: 'تعذّر التحميل'));
    }
    return Result.success(categories);
  }

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => Result.success(azkarByKey[categoryKey] ?? []);
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  _FakeCustomCategoryRepository({
    required this.categories,
    this.failure = false,
  });

  final List<CustomCategoryEntity> categories;
  final bool failure;

  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async {
    if (failure) return const Result.success(null);
    for (final category in categories) {
      if (category.id == id) return Result.success(category);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async {
    if (failure) {
      return const Result.failure(CacheFailure(message: 'تعذّر التحميل'));
    }
    return Result.success(categories);
  }

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async => const Result.success(null);
}
