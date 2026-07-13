import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_state.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_azkar_categories_section.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockAzkarCategoriesCubit extends Mock implements AzkarCategoriesCubit {}

void main() {
  late MockAzkarCategoriesCubit mockCubit;

  setUp(() {
    registerTestServices();
    final haptic = sl<IHapticService>();
    when(haptic.playVibrate).thenAnswer((_) async {});
    when(haptic.playDoubleVibrate).thenAnswer((_) async {});

    mockCubit = MockAzkarCategoriesCubit();
    when(mockCubit.loadCategories).thenAnswer((_) async {});
    when(mockCubit.close).thenAnswer((_) async {});

    sl.registerFactory<AzkarCategoriesCubit>(() => mockCubit);
  });

  tearDown(sl.reset);

  Future<void> pumpSection(WidgetTester tester) async {
    setTestScreenSize(tester);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: CustomScrollView(
              slivers: [HomeAzkarCategoriesSection()],
            ),
          ),
        ),
        GoRoute(
          path: '/azkar-list/:categoryId',
          name: 'azkar-list',
          builder: (context, state) => const SizedBox.shrink(),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );

    await tester.pump();
  }

  group('HomeAzkarCategoriesSection', () {
    testWidgets(
      'renders category titles and icons when state is Loaded',
      (tester) async {
        const loadedState = AzkarCategoriesLoaded([
          CategoryEntity(id: 2, title: 'أذكار الصباح'),
          CategoryEntity(id: 3, title: 'أذكار المساء'),
        ]);

        when(() => mockCubit.state).thenReturn(loadedState);
        when(() => mockCubit.stream).thenAnswer(
          (_) => Stream<AzkarCategoriesState>.value(loadedState),
        );

        await pumpSection(tester);
        await tester.pumpAndSettle();

        expect(find.text('الصباح'), findsOneWidget);
        expect(find.text('المساء'), findsOneWidget);
      },
    );

    testWidgets(
      'renders skeleton when state is loading',
      (tester) async {
        when(() => mockCubit.state).thenReturn(AzkarCategoriesLoading());
        when(() => mockCubit.stream).thenAnswer(
          (_) => Stream<AzkarCategoriesState>.value(
            AzkarCategoriesLoading(),
          ),
        );

        await pumpSection(tester);
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('تحميل القسم...'), findsWidgets);
      },
    );

    testWidgets(
      'shows nothing when state is error',
      (tester) async {
        when(() => mockCubit.state).thenReturn(
          const AzkarCategoriesError('Error message'),
        );
        when(() => mockCubit.stream).thenAnswer(
          (_) => Stream<AzkarCategoriesState>.value(
            const AzkarCategoriesError('Error message'),
          ),
        );

        await pumpSection(tester);
        await tester.pumpAndSettle();

        expect(find.text('الصباح'), findsNothing);
        expect(find.text('المساء'), findsNothing);
      },
    );

    testWidgets(
      'renders category titles without "أذكار " prefix',
      (tester) async {
        const loadedState = AzkarCategoriesLoaded([
          CategoryEntity(id: 5, title: 'أذكار الاستيقاظ'),
        ]);

        when(() => mockCubit.state).thenReturn(loadedState);
        when(() => mockCubit.stream).thenAnswer(
          (_) => Stream<AzkarCategoriesState>.value(loadedState),
        );

        await pumpSection(tester);
        await tester.pumpAndSettle();

        expect(find.text('الاستيقاظ'), findsOneWidget);
        expect(find.text('أذكار الاستيقاظ'), findsNothing);
      },
    );
  });
}
