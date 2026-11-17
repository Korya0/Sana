import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';

void main() {
  group('AzkarCubit', () {
    test(
      'applyCategoryUpdate keeps progress and clamps it to new targets',
      () async {
        final azkarRepository = _FakeAzkarRepository(
          azkar: [
            const ZikrEntity(id: 1, text: 'أ', count: 5),
            const ZikrEntity(id: 2, text: 'ب', count: 3),
          ],
        );
        final customRepository = _FakeCustomCategoryRepository();
        final cubit = _createCubit(azkarRepository, customRepository);

        await cubit.loadAzkar('custom_1', categoryTitle: 'قسم');
        cubit.incrementZikr(1);
        cubit.incrementZikr(1);
        cubit.incrementZikr(1);
        cubit.incrementZikr(1);

        cubit.applyCategoryUpdate(
          [
            const ZikrEntity(id: 1, text: 'أ', count: 2),
            const ZikrEntity(id: 3, text: 'ج', count: 7),
          ],
          isModified: false,
          resolvedTitle: 'قسم معدّل',
        );

        final state = cubit.state as AzkarLoaded;
        expect(state.azkar.map((zikr) => zikr.id), [1, 3]);
        expect(state.counters, {1: 2, 3: 0});
        expect(state.isModified, isFalse);
        expect(state.resolvedTitle, 'قسم معدّل');
      },
    );

    test(
      'loadAzkar keeps a modified built-in as built-in with its original name',
      () async {
        final azkarRepository = _FakeAzkarRepository(
          azkar: [const ZikrEntity(id: 1, text: 'أ', count: 5)],
          categories: const [
            AzkarCategoryEntity(
              key: 'morning',
              title: 'أذكار الصباح',
              cardTitle: 'الصباح',
            ),
          ],
        );
        final customRepository = _FakeCustomCategoryRepository(
          category: const CustomCategoryEntity(
            id: 'morning',
            name: 'اسم معدّل',
            azkar: [ZikrEntity(id: 1, text: 'أ', count: 9)],
          ),
        );
        final cubit = _createCubit(azkarRepository, customRepository);

        await cubit.loadAzkar('morning', categoryTitle: 'اسم معدّل من الخارج');

        final state = cubit.state as AzkarLoaded;
        expect(state.isCustom, isFalse);
        expect(state.isModified, isTrue);
        expect(state.resolvedTitle, 'أذكار الصباح');
      },
    );

    test('loadAzkar marks a user-created category as custom', () async {
      final azkarRepository = _FakeAzkarRepository(
        azkar: [const ZikrEntity(id: 1, text: 'أ', count: 5)],
      );
      final customRepository = _FakeCustomCategoryRepository();
      final cubit = _createCubit(azkarRepository, customRepository);

      await cubit.loadAzkar('custom_1', categoryTitle: 'مخصص');

      final state = cubit.state as AzkarLoaded;
      expect(state.isCustom, isTrue);
      expect(state.isModified, isFalse);
    });

    test(
      'restoreCategory returns a failure and keeps the loaded state when the '
      'delete fails',
      () async {
        final azkarRepository = _FakeAzkarRepository(
          azkar: [const ZikrEntity(id: 1, text: 'أ', count: 5)],
        );
        final customRepository = _FakeCustomCategoryRepository(
          deleteFailure: true,
        );
        final cubit = _createCubit(azkarRepository, customRepository);

        await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');
        final result = await cubit.restoreCategory(
          'morning',
          categoryTitle: 'أذكار الصباح',
        );

        expect(result, isA<FailureResult<void>>());
        expect(cubit.state, isA<AzkarLoaded>());
      },
    );

    test('loadAzkar reports the failure message', () async {
      final cubit = _createCubit(
        _FakeAzkarRepository(azkar: const [], failure: true),
        _FakeCustomCategoryRepository(),
      );

      await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');

      expect((cubit.state as AzkarError).message, 'تعذّر التحميل');
    });

    test('loadAzkar is empty when the category has no azkar', () async {
      final cubit = _createCubit(
        _FakeAzkarRepository(azkar: const []),
        _FakeCustomCategoryRepository(),
      );

      await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');

      expect(cubit.state, isA<AzkarEmpty>());
    });

    test(
      'incrementZikr completes at the target and ignores extra taps',
      () async {
        final cubit = _createCubit(
          _FakeAzkarRepository(
            azkar: [const ZikrEntity(id: 1, text: 'أ', count: 2)],
          ),
          _FakeCustomCategoryRepository(),
        );
        await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');

        expect(cubit.incrementZikr(1), isA<CounterIncremented>());
        expect(cubit.incrementZikr(1), isA<CounterCompleted>());
        expect(cubit.incrementZikr(1), isA<CounterIgnored>());

        final state = cubit.state as AzkarLoaded;
        expect(state.counters[1], 2);
        expect(state.isAllCompleted, isTrue);
      },
    );

    test('incrementZikr ignores an unknown zikr', () async {
      final cubit = _createCubit(
        _FakeAzkarRepository(
          azkar: [const ZikrEntity(id: 1, text: 'أ', count: 2)],
        ),
        _FakeCustomCategoryRepository(),
      );
      await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');

      expect(cubit.incrementZikr(99), isA<CounterIgnored>());
    });

    test('resetCounter clears the progress', () async {
      final cubit = _createCubit(
        _FakeAzkarRepository(
          azkar: [const ZikrEntity(id: 1, text: 'أ', count: 5)],
        ),
        _FakeCustomCategoryRepository(),
      );
      await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');
      cubit.incrementZikr(1);
      cubit.incrementZikr(1);

      cubit.resetCounter(1);

      final state = cubit.state as AzkarLoaded;
      expect(state.counters[1], 0);
      expect(state.hasStarted, isFalse);
    });

    test(
      'restoreCategory restores the built-in azkar after a successful delete',
      () async {
        final azkarRepository = _FakeAzkarRepository(
          azkar: [const ZikrEntity(id: 1, text: 'الأصل', count: 5)],
          categories: const [
            AzkarCategoryEntity(
              key: 'morning',
              title: 'أذكار الصباح',
              cardTitle: 'الصباح',
            ),
          ],
        );
        final customRepository = _FakeCustomCategoryRepository(
          category: const CustomCategoryEntity(
            id: 'morning',
            name: 'اسم معدّل',
            azkar: [ZikrEntity(id: 1, text: 'معدّل', count: 9)],
          ),
        );
        final cubit = _createCubit(azkarRepository, customRepository);
        await cubit.loadAzkar('morning', categoryTitle: 'أذكار الصباح');
        expect((cubit.state as AzkarLoaded).isModified, isTrue);

        final result = await cubit.restoreCategory(
          'morning',
          categoryTitle: 'أذكار الصباح',
        );

        expect(result, isA<Success<void>>());
        final state = cubit.state as AzkarLoaded;
        expect(state.isModified, isFalse);
        expect(state.azkar.single.text, 'الأصل');
      },
    );

    test(
      'loadAzkar keeps the caller title for user-created categories',
      () async {
        final cubit = _createCubit(
          _FakeAzkarRepository(
            azkar: [const ZikrEntity(id: 1, text: 'أ', count: 1)],
          ),
          _FakeCustomCategoryRepository(),
        );

        await cubit.loadAzkar('custom_1', categoryTitle: 'قسمي');

        expect((cubit.state as AzkarLoaded).resolvedTitle, 'قسمي');
      },
    );

    test(
      'loadAzkar resolves the stored name when no title is passed',
      () async {
        const category = CustomCategoryEntity(
          id: 'custom_1',
          name: 'قسمي المخزّن',
          azkar: [ZikrEntity(id: 1, text: 'أ', count: 1)],
        );
        final cubit = _createCubit(
          _FakeAzkarRepository(
            azkar: [const ZikrEntity(id: 1, text: 'أ', count: 1)],
          ),
          _FakeCustomCategoryRepository(category: category),
        );

        await cubit.loadAzkar(
          'custom_1',
          categoryTitle: AppStrings.azkarHeader,
        );

        expect(
          (cubit.state as AzkarLoaded).resolvedTitle,
          'قسمي المخزّن',
        );
      },
    );

    test('deleteCustomCategory reports the repository failure', () async {
      final cubit = _createCubit(
        _FakeAzkarRepository(azkar: const []),
        _FakeCustomCategoryRepository(deleteFailure: true),
      );

      final result = await cubit.deleteCustomCategory('custom_1');

      expect(result, isA<FailureResult<void>>());
    });

    test('applySavedCategory derives metadata from its own state', () async {
      final cubit = _createCubit(
        _FakeAzkarRepository(
          azkar: const [
            ZikrEntity(id: 1, text: 'أ', count: 3),
          ],
        ),
        _FakeCustomCategoryRepository(),
      );
      await cubit.loadAzkar('morning', categoryTitle: 'أذكار');

      cubit.applySavedCategory(
        const CustomCategoryEntity(
          id: 'custom_1',
          name: 'اسم جديد',
          azkar: [ZikrEntity(id: 1, text: 'أ', count: 5)],
        ),
      );

      final state = cubit.state as AzkarLoaded;
      expect(state.resolvedTitle, 'اسم جديد');
      expect(state.isModified, isTrue);
      expect(state.azkar.single.count, 5);
    });
  });
}

AzkarCubit _createCubit(
  _FakeAzkarRepository azkarRepository,
  _FakeCustomCategoryRepository customRepository,
) => AzkarCubit(
  GetZikrsByCategoryUseCase(azkarRepository),
  GetAzkarCategoriesUseCase(azkarRepository),
  DeleteCustomCategoryUseCase(customRepository),
  customRepository,
);

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository({
    required this.azkar,
    this.categories = const [],
    this.failure = false,
  });

  final List<ZikrEntity> azkar;
  final List<AzkarCategoryEntity> categories;
  final bool failure;

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
  ) async {
    if (failure) {
      return const Result.failure(CacheFailure(message: 'تعذّر التحميل'));
    }
    return Result.success(azkar);
  }
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  _FakeCustomCategoryRepository({this.category, this.deleteFailure = false});

  CustomCategoryEntity? category;
  final bool deleteFailure;

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    if (deleteFailure) {
      return const Result.failure(
        CacheFailure(message: 'تعذّر حذف القسم'),
      );
    }
    category = null;
    return const Result.success(null);
  }

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => Result.success(category);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category) async {
    this.category = category;
    return const Result.success(null);
  }
}
