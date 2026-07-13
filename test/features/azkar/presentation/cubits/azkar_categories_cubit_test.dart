import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_state.dart';
import 'package:sana/core/error/error.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

void main() {
  late MockGetCategoriesUseCase mockUseCase;
  late AzkarCategoriesCubit cubit;

  setUp(() {
    mockUseCase = MockGetCategoriesUseCase();
    cubit = AzkarCategoriesCubit(mockUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AzkarCategoriesCubit', () {
    test('initial state is AzkarCategoriesInitial', () {
      expect(cubit.state, isA<AzkarCategoriesInitial>());
    });

    test('emits [Loading, Loaded] when usecase returns data', () async {
      final tCategories = [const CategoryEntity(id: 1, title: 'Test')];
      when(() => mockUseCase()).thenAnswer((_) async => Result.success(tCategories));

      final expectedStates = [
        isA<AzkarCategoriesLoading>(),
        isA<AzkarCategoriesLoaded>().having((s) => s.categories, 'categories', tCategories),
      ];

      final expectFuture = expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadCategories(); await expectFuture;
    });

    test('emits [Loading, Empty] when usecase returns empty list', () async {
      when(() => mockUseCase()).thenAnswer((_) async => const Result.success([]));

      final expectedStates = [
        isA<AzkarCategoriesLoading>(),
        isA<AzkarCategoriesEmpty>(),
      ];

      final expectFuture = expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadCategories(); await expectFuture;
    });

    test('emits [Loading, Error] when usecase returns failure', () async {
      when(() => mockUseCase()).thenAnswer((_) async => const Result.failure(CacheFailure(message: 'Error')));

      final expectedStates = [
        isA<AzkarCategoriesLoading>(),
        isA<AzkarCategoriesError>().having((s) => s.message, 'message', 'Error'),
      ];

      final expectFuture = expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadCategories(); await expectFuture;
    });
  });
}
