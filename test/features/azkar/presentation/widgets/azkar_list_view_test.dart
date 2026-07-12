import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockGetAzkarByCategoryUseCase extends Mock
    implements GetAzkarByCategoryUseCase {}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

/// A real AzkarCubit subclass that exposes emit for test control.
/// Overrides loadAzkar so it doesn't interfere with pre-set state.
class TestAzkarCubit extends AzkarCubit {
  TestAzkarCubit() : super(_createMockUseCase(), MockGetCategoriesUseCase());

  static GetAzkarByCategoryUseCase _createMockUseCase() {
    final useCase = MockGetAzkarByCategoryUseCase();
    when(() => useCase.call(any())).thenAnswer(
      (_) async => const Result.success(<ZikrEntity>[]),
    );
    return useCase;
  }

  @override
  Future<void> loadAzkar(int categoryId, {String fallbackTitle = AppStrings.azkarHeader}) async {
    // No-op: test controls state via emitState()
  }

  void emitState(AzkarState newState) => emit(newState);
}

void main() {
  late TestAzkarCubit testCubit;

  setUp(() {
    registerTestServices();
    final haptic = sl<IHapticService>();
    when(haptic.playVibrate).thenAnswer((_) async {});
    when(haptic.playDoubleVibrate).thenAnswer((_) async {});

    testCubit = TestAzkarCubit();
    sl.registerFactory<AzkarCubit>(() => testCubit);
  });

  tearDown(sl.reset);

  /// Pumps [AzkarListView] inside a GoRouter with a parent route so that
  /// context.pop() works without throwing "nothing to pop".
  Future<void> pumpListView(
    WidgetTester tester, {
    int categoryId = 1,
    String categoryTitle = 'أذكار الصباح',
    AzkarState? initialState,
  }) async {
    if (initialState != null) {
      testCubit.emitState(initialState);
    }

    final router = GoRouter(
      initialLocation: '/parent',
      routes: [
        GoRoute(
          path: '/parent',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Parent Screen')),
          ),
          routes: [
            GoRoute(
              path: 'azkar-list/:categoryId',
              name: 'azkar-list',
              builder: (context, state) => Scaffold(
                body: AzkarListView(
                  categoryId: categoryId,
                  categoryTitle: categoryTitle,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    setTestScreenSize(tester);
    // Navigate to the azkar-list route
    router.go('/parent/azkar-list/1');
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
    await tester.pump();
  }

  group('AzkarListView', () {
    testWidgets('renders the scaffold with category title', (tester) async {
      testCubit.emitState(
        const AzkarLoaded(
          azkar: [ZikrEntity(id: 1, text: 'Zikr 1', count: 3)],
          counters: {1: 0},
          resolvedTitle: 'الأذكار',
        ),
      );

      await pumpListView(tester);
      await tester.pumpAndSettle();

      expect(find.text('أذكار الصباح'), findsOneWidget);
    });

    testWidgets('shows AzkarLoaded state with correct hasStarted value', (
      tester,
    ) async {
      final zikrs = [
        const ZikrEntity(id: 1, text: 'Zikr 1', count: 3),
        const ZikrEntity(id: 2, text: 'Zikr 2', count: 3),
      ];

      testCubit.emitState(
        AzkarLoaded(azkar: zikrs, counters: {1: 1, 2: 0}, resolvedTitle: 'الأذكار'),
      );

      await pumpListView(tester);
      await tester.pumpAndSettle();

      final state = testCubit.state;
      expect(state, isA<AzkarLoaded>());
      final loaded = state as AzkarLoaded;
      expect(loaded.hasStarted, isTrue);
      expect(loaded.isAllCompleted, isFalse);
    });

    testWidgets('correctly detects isAllCompleted state', (tester) async {
      final zikrs = [
        const ZikrEntity(id: 1, text: 'Zikr 1', count: 1),
      ];

      testCubit.emitState(
        AzkarLoaded(azkar: zikrs, counters: {1: 0}, resolvedTitle: 'الأذكار'),
      );

      await pumpListView(tester);
      await tester.pump();

      var currentState = testCubit.state;
      expect((currentState as AzkarLoaded).isAllCompleted, isFalse);

      testCubit.emitState(
        AzkarLoaded(azkar: zikrs, counters: {1: 1}, resolvedTitle: 'الأذكار'),
      );
      await tester.pump(const Duration(milliseconds: 100));

      currentState = testCubit.state;
      expect((currentState as AzkarLoaded).isAllCompleted, isTrue);

      // Pump enough to let the BlocListener's Future.delayed(500ms) timer and
      // AppToast's autoCloseDuration (2s) fire so no timers remain pending.
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('renders skeleton loading state', (tester) async {
      testCubit.emitState(AzkarLoading());

      await pumpListView(tester);
      // Skeletonizer has infinite shimmer → use pump() not pumpAndSettle()
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.text(
          'محتوى تجريبي طويل ليظهر بنفس المساحة تماما محتوى تجريبي طويل ليظهر بنفس المساحة تماما',
        ),
        findsWidgets,
      );
    });
  });
}
