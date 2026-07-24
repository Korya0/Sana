import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_categories_usecase.dart';

class MockAzkarRepository extends Mock implements AzkarRepository {}

void main() {
  late GetCategoriesUseCase useCase;
  late MockAzkarRepository mockRepository;

  setUp(() {
    mockRepository = MockAzkarRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  test('call() should invoke repository.getCategories() and return the result', () async {
    final categories = [
      const CategoryEntity(id: 1, title: 'أذكار الصباح'),
      const CategoryEntity(id: 2, title: 'أذكار المساء'),
    ];
    when(() => mockRepository.getCategories()).thenAnswer(
      (_) async => Result.success(categories),
    );

    final result = await useCase.call();

    expect(result, isA<Success<List<CategoryEntity>>>());
    expect((result as Success).data, categories);
    verify(() => mockRepository.getCategories()).called(1);
  });

  test('call() should return Result.failure from repository', () async {
    when(() => mockRepository.getCategories()).thenAnswer(
      (_) async => const Result.failure(
        CacheFailure(message: 'Failed to load categories'),
      ),
    );

    final result = await useCase.call();

    expect(result, isA<FailureResult<List<CategoryEntity>>>());
    verify(() => mockRepository.getCategories()).called(1);
  });
}
