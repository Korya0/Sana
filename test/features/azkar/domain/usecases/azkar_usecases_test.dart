import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/i_azkar_repository.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';

class MockAzkarRepository extends Mock implements IAzkarRepository {}

void main() {
  late MockAzkarRepository mockRepository;
  late GetCategoriesUseCase getCategoriesUseCase;
  late GetAzkarByCategoryUseCase getAzkarByCategoryUseCase;

  setUp(() {
    mockRepository = MockAzkarRepository();
    getCategoriesUseCase = GetCategoriesUseCase(mockRepository);
    getAzkarByCategoryUseCase = GetAzkarByCategoryUseCase(mockRepository);
  });

  group('GetCategoriesUseCase', () {
    const tCategories = [CategoryEntity(id: 1, title: 'Test')];

    test('should return categories from repository', () async {
      when(() => mockRepository.getCategories()).thenAnswer((_) async => const Result.success(tCategories));

      final result = await getCategoriesUseCase();

      expect(result, isA<Success<List<CategoryEntity>>>());
      expect((result as Success).data, tCategories);
      verify(() => mockRepository.getCategories()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('GetAzkarByCategoryUseCase', () {
    const tAzkar = [ZikrEntity(id: 1, text: 'Zikr', count: 1)];

    test('should return azkar from repository for given category', () async {
      when(() => mockRepository.getAzkarByCategory(1)).thenAnswer((_) async => const Result.success(tAzkar));

      final result = await getAzkarByCategoryUseCase(1);

      expect(result, isA<Success<List<ZikrEntity>>>());
      expect((result as Success).data, tAzkar);
      verify(() => mockRepository.getAzkarByCategory(1)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
