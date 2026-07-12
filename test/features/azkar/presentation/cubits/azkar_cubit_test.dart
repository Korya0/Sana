import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';

import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';

class MockGetAzkarByCategoryUseCase extends Mock
    implements GetAzkarByCategoryUseCase {}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

void main() {
  late MockGetAzkarByCategoryUseCase mockUseCase;
  late MockGetCategoriesUseCase mockCategoriesUseCase;
  late AzkarCubit cubit;

  setUp(() {
    mockUseCase = MockGetAzkarByCategoryUseCase();
    mockCategoriesUseCase = MockGetCategoriesUseCase();
    when(() => mockCategoriesUseCase.call()).thenAnswer(
        (_) async => const Result<List<CategoryEntity>>.success([
              CategoryEntity(id: 1, title: 'الأذكار'),
            ]));
    cubit = AzkarCubit(mockUseCase, mockCategoriesUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AzkarCubit loadAzkar', () {
    test('initial state is AzkarInitial', () {
      expect(cubit.state, isA<AzkarInitial>());
    });

    test('emits [Loading, Loaded] when usecase returns data', () async {
      final tAzkar = [const ZikrEntity(id: 1, text: 'Zikr 1', count: 3)];
      when(
        () => mockUseCase(1),
      ).thenAnswer((_) async => Result<List<ZikrEntity>>.success(tAzkar));

      final expectedStates = [
        isA<AzkarLoading>(),
        isA<AzkarLoaded>()
            .having((s) => s.azkar, 'azkar', tAzkar)
            .having((s) => s.counters[1], 'counters[1]', 0)
            .having((s) => s.resolvedTitle, 'resolvedTitle', 'الأذكار'),
      ];

      final expectFuture = expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAzkar(1); await expectFuture;
    });

    test('emits [Loading, Empty] when usecase returns empty list', () async {
      when(
        () => mockUseCase(1),
      ).thenAnswer((_) async => const Result<List<ZikrEntity>>.success([]));

      final expectedStates = [
        isA<AzkarLoading>(),
        isA<AzkarEmpty>(),
      ];

      final expectFuture = expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAzkar(1); await expectFuture;
    });

    test('emits [Loading, Error] when usecase returns failure', () async {
      when(() => mockUseCase(1)).thenAnswer(
        (_) async => const Result<List<ZikrEntity>>.failure(CacheFailure(message: 'Error')),
      );

      final expectedStates = [
        isA<AzkarLoading>(),
        isA<AzkarError>().having((s) => s.message, 'message', 'Error'),
      ];

      final expectFuture = expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadAzkar(1); await expectFuture;
    });
  });

  group('AzkarCubit incrementZikr', () {
    final tAzkar = [
      const ZikrEntity(id: 1, text: 'Zikr 1', count: 2),
      const ZikrEntity(id: 2, text: 'Zikr 2', count: 1),
    ];

    setUp(() async {
      when(
        () => mockUseCase(1),
      ).thenAnswer((_) async => Result<List<ZikrEntity>>.success(tAzkar));
      await cubit.loadAzkar(1);
    });

    test('increments counter and returns ZikrIncremented when count < max', () {
      final result = cubit.incrementZikr(1);

      expect(result, isA<ZikrIncremented>());
      final state = cubit.state as AzkarLoaded;
      expect(state.counters[1], 1);
    });

    test(
      'increments counter and returns ZikrCompleted when count reaches max',
      () {
        cubit.incrementZikr(2); // required count is 1
        final result = cubit.incrementZikr(2); // Should be ignored now

        expect(result, isA<ZikrIgnored>());
        final state = cubit.state as AzkarLoaded;
        expect(state.counters[2], 1);
        expect(state.isAllCompleted, false);
      },
    );

    test('incrementZikr exactly at max returns ZikrCompleted', () {
      final result = cubit.incrementZikr(2);
      expect(result, isA<ZikrCompleted>());
    });

    test('returns ZikrIgnored when zikr id not found', () {
      final result = cubit.incrementZikr(99);
      expect(result, isA<ZikrIgnored>());
    });
  });

  group('AzkarLoaded state logic', () {
    test('nextIncompleteIndex returns correct index', () {
      const state = AzkarLoaded(
        azkar: [
          ZikrEntity(id: 1, text: 'Z', count: 1),
          ZikrEntity(id: 2, text: 'Z', count: 1),
          ZikrEntity(id: 3, text: 'Z', count: 1),
        ],
        counters: {1: 1, 2: 0, 3: 0},
        resolvedTitle: 'الأذكار',
      );

      // Current is 0 (completed). Next incomplete is 1.
      expect(state.nextIncompleteIndex(0), 1);
      // Current is 1 (incomplete). Next incomplete after 1 is 2.
      expect(state.nextIncompleteIndex(1), 2);
      // Current is 2. No more after 2.
      expect(state.nextIncompleteIndex(2), isNull);
    });

    test('isAllCompleted returns true when all are reached', () {
      const state = AzkarLoaded(
        azkar: [
          ZikrEntity(id: 1, text: 'Z', count: 1),
        ],
        counters: {1: 1},
        resolvedTitle: 'الأذكار',
      );
      expect(state.isAllCompleted, true);
    });

    test('hasStarted returns true if any counter > 0', () {
      const state = AzkarLoaded(
        azkar: [
          ZikrEntity(id: 1, text: 'Z', count: 2),
        ],
        counters: {1: 1},
        resolvedTitle: 'الأذكار',
      );
      expect(state.hasStarted, true);
    });
  });
}
