import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/zikr_increment_result.dart';

class MockGetAzkarByCategoryUseCase extends Mock implements GetAzkarByCategoryUseCase {}
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AzkarCubit cubit;
  late MockGetAzkarByCategoryUseCase mockGetAzkar;
  late MockGetCategoriesUseCase mockGetCategories;

  const zikr1 = ZikrEntity(id: 1, text: 'سُبْحَانَ اللَّهِ', count: 3);
  const zikr2 = ZikrEntity(id: 2, text: 'الْحَمْدُ لِلَّهِ', count: 5);
  const categories = [
    CategoryEntity(id: 2, title: 'أذكار الصباح'),
    CategoryEntity(id: 3, title: 'أذكار المساء'),
  ];
  final azkarList = [zikr1, zikr2];

  setUp(() {
    mockGetAzkar = MockGetAzkarByCategoryUseCase();
    mockGetCategories = MockGetCategoriesUseCase();
    cubit = AzkarCubit(mockGetAzkar, mockGetCategories);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state should be AzkarInitial', () {
    expect(cubit.state, isA<AzkarInitial>());
  });

  Future<void> loadDefault() async {
    when(() => mockGetCategories()).thenAnswer(
      (_) async => const Result.success(categories),
    );
    when(() => mockGetAzkar(2)).thenAnswer(
      (_) async => Result.success(azkarList),
    );
    await cubit.loadAzkar(2);
  }

  group('loadAzkar()', () {
    test('should emit AzkarLoading then AzkarLoaded on success', () async {
      when(() => mockGetCategories()).thenAnswer(
        (_) async => const Result.success(categories),
      );
      when(() => mockGetAzkar(2)).thenAnswer(
        (_) async => Result.success(azkarList),
      );

      await cubit.loadAzkar(2);

      expect(cubit.state, isA<AzkarLoaded>());
      final loaded = cubit.state as AzkarLoaded;
      expect(loaded.azkar.length, 2);
      expect(loaded.counters, {1: 0, 2: 0});
    });

    test('should resolve title from categories when fallbackTitle is default', () async {
      when(() => mockGetCategories()).thenAnswer(
        (_) async => const Result.success(categories),
      );
      when(() => mockGetAzkar(2)).thenAnswer(
        (_) async => Result.success(azkarList),
      );

      await cubit.loadAzkar(2);

      final loaded = cubit.state as AzkarLoaded;
      expect(loaded.resolvedTitle, 'أذكار الصباح');
    });

    test('should use fallbackTitle when categories list is empty', () async {
      when(() => mockGetCategories()).thenAnswer(
        (_) async => const Result.success(<CategoryEntity>[]),
      );
      when(() => mockGetAzkar(2)).thenAnswer(
        (_) async => Result.success(azkarList),
      );

      await cubit.loadAzkar(2);

      final loaded = cubit.state as AzkarLoaded;
      expect(loaded.resolvedTitle, AppStrings.azkarHeader);
    });

    test('should use first category title if exact match not found', () async {
      when(() => mockGetCategories()).thenAnswer(
        (_) async => const Result.success(categories),
      );
      when(() => mockGetAzkar(99)).thenAnswer(
        (_) async => Result.success(azkarList),
      );

      await cubit.loadAzkar(99);

      final loaded = cubit.state as AzkarLoaded;
      expect(loaded.resolvedTitle, 'أذكار الصباح');
    });

    test('should emit AzkarEmpty when azkar list is empty', () async {
      when(() => mockGetCategories()).thenAnswer(
        (_) async => const Result.success(categories),
      );
      when(() => mockGetAzkar(2)).thenAnswer(
        (_) async => const Result.success(<ZikrEntity>[]),
      );

      await cubit.loadAzkar(2);

      expect(cubit.state, isA<AzkarEmpty>());
    });

    test('should emit AzkarError with message on failure', () async {
      when(() => mockGetCategories()).thenAnswer(
        (_) async => const Result.success(categories),
      );
      when(() => mockGetAzkar(2)).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'فشل التحميل'),
        ),
      );

      await cubit.loadAzkar(2);

      expect(cubit.state, isA<AzkarError>());
      expect((cubit.state as AzkarError).message, 'فشل التحميل');
    });
  });

  group('incrementZikr()', () {
    test('should return ZikrIncremented and increment counter by 1', () async {
      await loadDefault();

      final result = cubit.incrementZikr(1);

      expect(result, isA<ZikrIncremented>());
      final loaded = cubit.state as AzkarLoaded;
      expect(loaded.counters[1], 1);
    });

    test('should return ZikrCompleted when reaching max count', () async {
      await loadDefault();

      cubit
        ..incrementZikr(1)
        ..incrementZikr(1);
      final result = cubit.incrementZikr(1);

      expect(result, isA<ZikrCompleted>());
    });

    test('should return ZikrIgnored when incrementing already completed zikr', () async {
      await loadDefault();

      cubit
        ..incrementZikr(1)
        ..incrementZikr(1)
        ..incrementZikr(1);
      final result = cubit.incrementZikr(1);

      expect(result, isA<ZikrIgnored>());
    });

    test('should return ZikrIgnored when state is not AzkarLoaded', () {
      final result = cubit.incrementZikr(1);

      expect(result, isA<ZikrIgnored>());
    });

    test('should return ZikrIgnored if zikrId not found', () async {
      await loadDefault();

      final result = cubit.incrementZikr(999);

      expect(result, isA<ZikrIgnored>());
    });

    test('should emit updated state with new counters', () async {
      await loadDefault();

      cubit.incrementZikr(1);

      final loaded = cubit.state as AzkarLoaded;
      expect(loaded.counters[1], 1);
      expect(loaded.counters[2], 0);
    });
  });
}
