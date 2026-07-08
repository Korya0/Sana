import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class MockAzkarLocalDataSource extends Mock implements IAzkarLocalDataSource {}

void main() {
  late AzkarRepositoryImpl repository;
  late MockAzkarLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAzkarLocalDataSource();
    repository = AzkarRepositoryImpl(mockDataSource);
  });

  group('AzkarRepositoryImpl', () {
    const tCategories = [CategoryModel(id: 1, title: 'Test')];
    const tAzkar = [ZikrModel(id: 1, text: 'Zikr', count: 1)];

    test(
      'getCategories should return Success with models when datasource is successful',
      () async {
        when(
          () => mockDataSource.ensureDatabaseReady(),
        ).thenAnswer((_) async => {});
        when(
          () => mockDataSource.getCategories(),
        ).thenAnswer((_) async => tCategories);

        final result = await repository.getCategories();

        expect(result, isA<Success<List<CategoryEntity>>>());
        expect((result as Success<List<CategoryEntity>>).data, tCategories);
        verify(() => mockDataSource.ensureDatabaseReady()).called(1);
        verify(() => mockDataSource.getCategories()).called(1);
      },
    );

    test(
      'getCategories should return Failure when datasource throws',
      () async {
        when(
          () => mockDataSource.ensureDatabaseReady(),
        ).thenAnswer((_) async => {});
        when(() => mockDataSource.getCategories()).thenThrow(Exception());

        final result = await repository.getCategories();

        expect(result, isA<FailureResult<List<CategoryEntity>>>());
        expect((result as FailureResult<List<CategoryEntity>>).failure, isA<CacheFailure>());
      },
    );

    test(
      'getAzkarByCategory should return Success with models when datasource is successful',
      () async {
        // Recreate to test that _ensureReady is called again
        repository = AzkarRepositoryImpl(mockDataSource);

        when(
          () => mockDataSource.ensureDatabaseReady(),
        ).thenAnswer((_) async => {});
        when(
          () => mockDataSource.getAzkarByCategory(1),
        ).thenAnswer((_) async => tAzkar);

        final result = await repository.getAzkarByCategory(1);

        expect(result, isA<Success<List<ZikrEntity>>>());
        expect((result as Success<List<ZikrEntity>>).data, tAzkar);
        verify(() => mockDataSource.ensureDatabaseReady()).called(1);
        verify(() => mockDataSource.getAzkarByCategory(1)).called(1);
      },
    );

    test(
      'getAzkarByCategory should return Failure when datasource throws',
      () async {
        when(
          () => mockDataSource.ensureDatabaseReady(),
        ).thenAnswer((_) async => {});
        when(() => mockDataSource.getAzkarByCategory(1)).thenThrow(Exception());

        final result = await repository.getAzkarByCategory(1);

        expect(result, isA<FailureResult<List<ZikrEntity>>>());
        expect((result as FailureResult<List<ZikrEntity>>).failure, isA<CacheFailure>());
      },
    );
  });
}
