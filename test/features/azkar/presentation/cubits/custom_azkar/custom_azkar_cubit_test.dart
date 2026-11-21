import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';

void main() {
  group('CustomAzkarCubit', () {
    test('restores the app-owned name for built-in overrides', () async {
      final customRepository = _FakeCustomCategoryRepository(
        categories: const [
          CustomCategoryEntity(id: 'morning', name: 'اسم معدّل', azkar: []),
          CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
        ],
      );
      final azkarRepository = _FakeAzkarRepository(
        categories: const [
          AzkarCategoryEntity(
            key: 'morning',
            title: 'أذكار الصباح',
            cardTitle: 'الصباح',
          ),
        ],
      );
      final cubit = CustomAzkarCubit(
        getCustomCategoriesUseCase: GetCustomCategoriesUseCase(
          customRepository,
        ),
        saveCustomCategoryUseCase: SaveCustomCategoryUseCase(customRepository),
        deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(
          customRepository,
        ),
        getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(azkarRepository),
      );

      await cubit.loadCustomCategories();

      final state = cubit.state as CustomAzkarLoaded;
      expect(state.categories, hasLength(2));
      expect(state.categories[0].name, 'أذكار الصباح');
      expect(state.categories[1].name, 'قسمي');
    });

    test('emits empty when there are no custom categories', () async {
      final cubit = _createCubit(
        _FakeCustomCategoryRepository(categories: const []),
      );

      await cubit.loadCustomCategories();

      expect(cubit.state, isA<CustomAzkarEmpty>());
    });

    test('emits an error when loading fails', () async {
      final cubit = _createCubit(
        _FakeCustomCategoryRepository(categories: const [], loadFailure: true),
      );

      await cubit.loadCustomCategories();

      expect((cubit.state as CustomAzkarError).message, 'تعذّر التحميل');
    });

    test('save returns true and reloads the saved categories', () async {
      final repository = _FakeCustomCategoryRepository(categories: const []);
      final cubit = _createCubit(repository);

      final saved = await cubit.saveCustomCategory(
        const CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
      );

      expect(saved, isA<Success<void>>());
      final state = cubit.state as CustomAzkarLoaded;
      expect(state.categories.single.name, 'قسمي');
    });

    test(
      'save failure keeps the current state and returns the failure',
      () async {
        final cubit = _createCubit(
          _FakeCustomCategoryRepository(
            categories: const [],
            saveFailure: true,
          ),
        );
        await cubit.loadCustomCategories();

        final saved = await cubit.saveCustomCategory(
          const CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
        );

        expect(saved, isA<FailureResult<void>>());
        expect(cubit.state, isA<CustomAzkarEmpty>());
      },
    );

    test('delete returns true and removes the category', () async {
      final repository = _FakeCustomCategoryRepository(
        categories: const [
          CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
        ],
      );
      final cubit = _createCubit(repository);

      final deleted = await cubit.deleteCustomCategory('custom_1');

      expect(deleted, isA<Success<void>>());
      expect(cubit.state, isA<CustomAzkarEmpty>());
    });

    test(
      'delete failure keeps the current list and returns the failure',
      () async {
        final cubit = _createCubit(
          _FakeCustomCategoryRepository(
            categories: const [
              CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
            ],
            deleteFailure: true,
          ),
        );
        await cubit.loadCustomCategories();

        final deleted = await cubit.deleteCustomCategory('custom_1');

        expect(deleted, isA<FailureResult<void>>());
        final state = cubit.state as CustomAzkarLoaded;
        expect(state.categories.single.id, 'custom_1');
      },
    );
  });
}

CustomAzkarCubit _createCubit(_FakeCustomCategoryRepository customRepository) {
  final azkarRepository = _FakeAzkarRepository(categories: const []);
  return CustomAzkarCubit(
    getCustomCategoriesUseCase: GetCustomCategoriesUseCase(customRepository),
    saveCustomCategoryUseCase: SaveCustomCategoryUseCase(customRepository),
    deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(customRepository),
    getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(azkarRepository),
  );
}

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository({required this.categories});

  final List<AzkarCategoryEntity> categories;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      Result.success(categories);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  _FakeCustomCategoryRepository({
    required this.categories,
    this.loadFailure = false,
    this.saveFailure = false,
    this.deleteFailure = false,
  });

  List<CustomCategoryEntity> categories;
  final bool loadFailure;
  final bool saveFailure;
  final bool deleteFailure;

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    if (deleteFailure) {
      return const Result.failure(CacheFailure(message: 'تعذّر الحذف'));
    }
    categories = categories.where((c) => c.id != id).toList();
    return const Result.success(null);
  }

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async {
    for (final category in categories) {
      if (category.id == id) return Result.success(category);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async {
    if (loadFailure) {
      return const Result.failure(CacheFailure(message: 'تعذّر التحميل'));
    }
    return Result.success(categories);
  }

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async {
    if (saveFailure) {
      return const Result.failure(CacheFailure(message: 'تعذّر الحفظ'));
    }
    categories = [
      ...categories.where((c) => c.id != category.id),
      category,
    ];
    return const Result.success(null);
  }
}
