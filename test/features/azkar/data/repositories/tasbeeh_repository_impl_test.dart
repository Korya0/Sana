import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source.dart';
import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';
import 'package:sana/features/azkar/data/repositories/tasbeeh_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

void main() {
  group('TasbeehRepositoryImpl', () {
    late _FakeDataSource dataSource;
    late TasbeehRepositoryImpl repository;

    setUp(() {
      dataSource = _FakeDataSource();
      repository = TasbeehRepositoryImpl(dataSource, const _SilentLogger());
    });

    test('returns items on success', () async {
      final model = TasbeehItemModel(
        id: 't1',
        text: 'ذكر',
        currentCount: 0,
        lastUsedAt: DateTime(2026, 11, 17),
      );
      dataSource.items = [model];

      final result = await repository.getTasbeehItems();

      expect(result, isA<Success<List<TasbeehItemEntity>>>());
      expect((result as Success).data.single.id, 't1');
    });

    test('maps a load failure to CacheFailure', () async {
      dataSource.fail = true;

      final result = await repository.getTasbeehItems();

      final failure = result as FailureResult;
      expect(failure.failure, isA<CacheFailure>());
      expect(failure.failure.message, AppStrings.tasbeehLoadError);
    });

    test('converts the entity to a model before saving', () async {
      final entity = TasbeehItemEntity(
        id: 't1',
        text: 'ذكر',
        currentCount: 0,
        lastUsedAt: DateTime(2026, 11, 17),
      );

      final result = await repository.saveTasbeehItem(entity);

      expect(result, isA<Success<void>>());
      expect(dataSource.saved.single, isA<TasbeehItemModel>());
      expect(dataSource.saved.single.id, 't1');
    });

    test('maps a save failure to CacheFailure', () async {
      dataSource.fail = true;

      final result = await repository.saveTasbeehItem(
        TasbeehItemEntity(
          id: 't1',
          text: 'ذكر',
          currentCount: 0,
          lastUsedAt: DateTime(2026, 11, 17),
        ),
      );

      final failure = result as FailureResult;
      expect(failure.failure, isA<CacheFailure>());
      expect(failure.failure.message, AppStrings.tasbeehSaveError);
    });

    test('deletes an item', () async {
      final result = await repository.deleteTasbeehItem('t1');

      expect(result, isA<Success<void>>());
      expect(dataSource.deleted, ['t1']);
    });

    test('maps a delete failure to CacheFailure', () async {
      dataSource.fail = true;

      final result = await repository.deleteTasbeehItem('t1');

      final failure = result as FailureResult;
      expect(failure.failure, isA<CacheFailure>());
      expect(failure.failure.message, AppStrings.tasbeehDeleteError);
    });
  });
}

class _FakeDataSource implements TasbeehLocalDataSource {
  List<TasbeehItemModel> items = [];
  final List<TasbeehItemModel> saved = [];
  final List<String> deleted = [];
  bool fail = false;

  @override
  Future<List<TasbeehItemModel>> getTasbeehItems() async {
    if (fail) throw StateError('load failed');
    return items;
  }

  @override
  Future<void> saveTasbeehItem(TasbeehItemModel item) async {
    if (fail) throw StateError('save failed');
    saved.add(item);
  }

  @override
  Future<void> deleteTasbeehItem(String id) async {
    if (fail) throw StateError('delete failed');
    deleted.add(id);
  }
}

class _SilentLogger extends AppLogger {
  const _SilentLogger();

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}
}
