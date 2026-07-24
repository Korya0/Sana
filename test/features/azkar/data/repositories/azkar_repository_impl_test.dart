import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class MockIAzkarLocalDataSource extends Mock implements IAzkarLocalDataSource {}

void main() {
  late AzkarRepositoryImpl repository;
  late MockIAzkarLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockIAzkarLocalDataSource();
    repository = AzkarRepositoryImpl(mockDataSource);
  });

  group('getCategories()', () {
    test('should return Result.success with categories list', () async {
      final categoryModels = <CategoryModel>[
        const CategoryModel(id: 1, title: 'أذكار الصباح'),
        const CategoryModel(id: 2, title: 'أذكار المساء'),
      ];
      when(() => mockDataSource.ensureDatabaseReady()).thenAnswer((_) async {});
      when(() => mockDataSource.getCategories()).thenAnswer((_) async => categoryModels);

      final result = await repository.getCategories();

      expect(result, isA<Success<List<CategoryEntity>>>());
      final data = (result as Success<List<CategoryEntity>>).data;
      expect(data.length, 2);
    });

    test('should call ensureDatabaseReady() on first call only (lazy init)', () async {
      when(() => mockDataSource.ensureDatabaseReady()).thenAnswer((_) async {});
      when(() => mockDataSource.getCategories()).thenAnswer((_) async => <CategoryModel>[]);

      await repository.getCategories();
      await repository.getCategories();

      verify(() => mockDataSource.ensureDatabaseReady()).called(1);
      verify(() => mockDataSource.getCategories()).called(2);
    });

    test('should return Result.failure(CacheFailure) on exception', () async {
      when(() => mockDataSource.ensureDatabaseReady())
          .thenThrow(Exception('DB error'));

      final result = await repository.getCategories();

      expect(result, isA<FailureResult<List<CategoryEntity>>>());
      expect((result as FailureResult<List<CategoryEntity>>).failure, isA<CacheFailure>());
    });

    test('should log error on exception', () async {
      when(() => mockDataSource.ensureDatabaseReady())
          .thenThrow(Exception('DB error'));

      final result = await repository.getCategories();

      expect(result, isA<FailureResult<List<CategoryEntity>>>());
    });
  });

  group('getAzkarByCategory()', () {
    test('should return Result.success with azkar list', () async {
      final azkarModels = <ZikrModel>[
        const ZikrModel(id: 1, text: 'سُبْحَانَ اللَّهِ', count: 33),
      ];
      when(() => mockDataSource.ensureDatabaseReady()).thenAnswer((_) async {});
      when(() => mockDataSource.getAzkarByCategory(2)).thenAnswer((_) async => azkarModels);

      final result = await repository.getAzkarByCategory(2);

      expect(result, isA<Success<List<ZikrEntity>>>());
      final data = (result as Success<List<ZikrEntity>>).data;
      expect(data.length, 1);
    });

    test('should call ensureDatabaseReady() on first call', () async {
      when(() => mockDataSource.ensureDatabaseReady()).thenAnswer((_) async {});
      when(() => mockDataSource.getAzkarByCategory(any())).thenAnswer((_) async => <ZikrModel>[]);

      await repository.getAzkarByCategory(2);

      verify(() => mockDataSource.ensureDatabaseReady()).called(1);
    });

    test('should return Result.failure(CacheFailure) on exception', () async {
      when(() => mockDataSource.ensureDatabaseReady())
          .thenThrow(Exception('DB error'));

      final result = await repository.getAzkarByCategory(2);

      expect(result, isA<FailureResult<List<ZikrEntity>>>());
      expect((result as FailureResult<List<ZikrEntity>>).failure, isA<CacheFailure>());
    });

    test('should log error on exception', () async {
      when(() => mockDataSource.ensureDatabaseReady())
          .thenThrow(Exception('DB error'));

      final result = await repository.getAzkarByCategory(2);

      expect(result, isA<FailureResult<List<ZikrEntity>>>());
    });
  });
}
