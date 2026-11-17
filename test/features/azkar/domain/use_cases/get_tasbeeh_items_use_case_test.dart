import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';

void main() {
  test('returns items from the repository', () async {
    final repository = _FakeRepository();
    final useCase = GetTasbeehItemsUseCase(repository);

    final result = await useCase();

    expect(result, isA<Success<List<TasbeehItemEntity>>>());
    expect((result as Success).data, repository.items);
  });

  test('passes the repository failure through', () async {
    final repository = _FakeRepository(fail: true);
    final useCase = GetTasbeehItemsUseCase(repository);

    final result = await useCase();

    expect(result, isA<FailureResult<List<TasbeehItemEntity>>>());
  });
}

class _FakeRepository implements TasbeehRepository {
  _FakeRepository({this.fail = false});

  final bool fail;
  final List<TasbeehItemEntity> items = [
    TasbeehItemEntity(
      id: 't1',
      text: 'ذكر',
      currentCount: 0,
      lastUsedAt: DateTime(2026, 11, 17),
    ),
  ];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async => fail
      ? const Result.failure(CacheFailure(message: 'failed'))
      : Result.success(items);

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async =>
      const Result.success(null);

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async =>
      const Result.success(null);
}
