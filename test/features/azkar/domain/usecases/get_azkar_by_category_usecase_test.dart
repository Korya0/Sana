import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/i_azkar_repository.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';

class MockIAzkarRepository extends Mock implements IAzkarRepository {}

void main() {
  late GetAzkarByCategoryUseCase useCase;
  late MockIAzkarRepository mockRepository;

  setUp(() {
    mockRepository = MockIAzkarRepository();
    useCase = GetAzkarByCategoryUseCase(mockRepository);
  });

  test('call(categoryId) should invoke repository.getAzkarByCategory(categoryId)', () async {
    final azkar = [
      const ZikrEntity(id: 1, text: 'سُبْحَانَ اللَّهِ', count: 33),
    ];
    when(() => mockRepository.getAzkarByCategory(2)).thenAnswer(
      (_) async => Result.success(azkar),
    );

    final result = await useCase.call(2);

    expect(result, isA<Success<List<ZikrEntity>>>());
    expect((result as Success).data, azkar);
    verify(() => mockRepository.getAzkarByCategory(2)).called(1);
  });

  test('call(categoryId) should pass the correct categoryId', () async {
    when(() => mockRepository.getAzkarByCategory(any())).thenAnswer(
      (_) async => const Result.success(<ZikrEntity>[]),
    );

    await useCase.call(5);

    verify(() => mockRepository.getAzkarByCategory(5)).called(1);
  });
}
