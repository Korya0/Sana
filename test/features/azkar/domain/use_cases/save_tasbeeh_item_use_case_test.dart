import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';

void main() {
  final item = TasbeehItemEntity(
    id: 't1',
    text: 'ذكر',
    currentCount: 0,
    lastUsedAt: DateTime(2026, 11, 17),
  );

  test('saves the item through the repository', () async {
    final repository = _FakeRepository();
    final useCase = SaveTasbeehItemUseCase(repository);

    final result = await useCase(item);

    expect(result, isA<Success<void>>());
    expect(repository.saved, [item]);
  });

  test('passes the repository failure through', () async {
    final repository = _FakeRepository(fail: true);
    final useCase = SaveTasbeehItemUseCase(repository);

    final result = await useCase(item);

    expect(result, isA<FailureResult<void>>());
  });
}

class _FakeRepository implements TasbeehRepository {
  _FakeRepository({this.fail = false});

  final bool fail;
  final List<TasbeehItemEntity> saved = [];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(saved);

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    if (fail) return const Result.failure(CacheFailure(message: 'failed'));
    saved.add(item);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async =>
      const Result.success(null);
}
