import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_state.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

void main() {
  late AzkarCategoriesCubit cubit;
  late MockGetCategoriesUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetCategoriesUseCase();
    cubit = AzkarCategoriesCubit(mockUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state should be AzkarCategoriesInitial', () {
    expect(cubit.state, isA<AzkarCategoriesInitial>());
  });

  group('loadCategories()', () {
    test('should emit AzkarCategoriesLoading then AzkarCategoriesLoaded on success', () async {
      final categories = [
        const CategoryEntity(id: 1, title: 'أذكار الصباح'),
        const CategoryEntity(id: 2, title: 'أذكار المساء'),
      ];
      when(() => mockUseCase()).thenAnswer(
        (_) async => Result.success(categories),
      );

      expect(cubit.state, isA<AzkarCategoriesInitial>());

      await cubit.loadCategories();

      expect(cubit.state, isA<AzkarCategoriesLoaded>());
      expect((cubit.state as AzkarCategoriesLoaded).categories, categories);
    });

    test('should emit AzkarCategoriesEmpty when list is empty', () async {
      when(() => mockUseCase()).thenAnswer(
        (_) async => const Result.success(<CategoryEntity>[]),
      );

      await cubit.loadCategories();

      expect(cubit.state, isA<AzkarCategoriesEmpty>());
    });

    test('should emit AzkarCategoriesError on failure', () async {
      when(() => mockUseCase()).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Error loading'),
        ),
      );

      await cubit.loadCategories();

      expect(cubit.state, isA<AzkarCategoriesError>());
      expect((cubit.state as AzkarCategoriesError).message, 'Error loading');
    });
  });
}
