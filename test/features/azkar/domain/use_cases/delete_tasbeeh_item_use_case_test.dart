import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';

void main() {
  test('deletes through the repository', () async {
    final repository = _FakeRepository();
    final useCase = DeleteTasbeehItemUseCase(repository);

    final result = await useCase('t1');

    expect(result, isA<Success<void>>());
    expect(repository.deleted, ['t1']);
  });

  test('passes the repository failure through', () async {
    final repository = _FakeRepository(fail: true);
    final useCase = DeleteTasbeehItemUseCase(repository);

    final result = await useCase('t1');

    expect(result, isA<FailureResult<void>>());
  });
}

class _FakeRepository implements TasbeehRepository {
  _FakeRepository({this.fail = false});

  final bool fail;
  final List<String> deleted = [];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async =>
      const Result.success(null);

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    if (fail) return const Result.failure(CacheFailure(message: 'failed'));
    deleted.add(id);
    return const Result.success(null);
  }
}
