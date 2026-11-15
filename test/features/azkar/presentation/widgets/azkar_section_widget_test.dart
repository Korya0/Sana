import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_section/azkar_section_widget.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_categories_skeleton.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_card.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_actions_bottom_sheet.dart';

void main() {
  group('AzkarSectionWidget', () {
    testWidgets('shows the skeleton before the first load', (tester) async {
      await _pump(tester, _cubit(categories: const []));

      expect(find.byType(AzkarCategoriesSkeleton), findsOneWidget);
    });

    testWidgets('renders a card per category', (tester) async {
      final cubit = _cubit(
        categories: const [
          AzkarCategoryEntity(
            key: 'morning',
            title: 'أذكار الصباح',
            cardTitle: 'الصباح',
          ),
          AzkarCategoryEntity(
            key: 'evening',
            title: 'أذكار المساء',
            cardTitle: 'المساء',
          ),
        ],
      );
      await cubit.loadCategories();

      await _pump(tester, cubit);

      expect(find.byType(AzkarCategoryCard), findsNWidgets(2));
      expect(find.text('الصباح'), findsOneWidget);
      expect(find.text('المساء'), findsOneWidget);
    });

    testWidgets('shows the empty message when there are no categories', (
      tester,
    ) async {
      final cubit = _cubit(categories: const []);
      await cubit.loadCategories();

      await _pump(tester, cubit);

      expect(find.text(AppStrings.azkarCategoriesEmpty), findsOneWidget);
    });

    testWidgets('shows the error message and retries', (tester) async {
      final repository = _FakeAzkarRepository(
        categories: const [],
        failure: true,
      );
      final cubit = AzkarCategoriesCubit(
        GetAzkarCategoriesUseCase(repository),
        GetCustomCategoriesUseCase(_FakeCustomAzkarRepository()),
      );
      await cubit.loadCategories();

      await _pump(tester, cubit);
      expect(find.text('تعذّر التحميل'), findsOneWidget);

      await tester.tap(find.text(AppStrings.tryAgain));
      await tester.pumpAndSettle();

      expect(repository.categoryCalls, 2);
    });

    testWidgets('long press opens the category actions sheet', (tester) async {
      final cubit = _cubit(
        categories: const [
          AzkarCategoryEntity(
            key: 'morning',
            title: 'أذكار الصباح',
            cardTitle: 'الصباح',
          ),
        ],
      );
      await cubit.loadCategories();
      await _pump(tester, cubit);

      await tester.longPress(find.text('الصباح'));
      await tester.pumpAndSettle();

      expect(find.byType(AzkarCategoryActionsBottomSheet), findsOneWidget);
    });
  });
}

Future<void> _pump(WidgetTester tester, AzkarCategoriesCubit cubit) =>
    tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(
            body: CustomScrollView(slivers: [AzkarSectionWidget()]),
          ),
        ),
      ),
    );

AzkarCategoriesCubit _cubit({required List<AzkarCategoryEntity> categories}) =>
    AzkarCategoriesCubit(
      GetAzkarCategoriesUseCase(_FakeAzkarRepository(categories: categories)),
      GetCustomCategoriesUseCase(_FakeCustomAzkarRepository()),
    );

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository({required this.categories, this.failure = false});

  final List<AzkarCategoryEntity> categories;
  final bool failure;
  int categoryCalls = 0;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async {
    categoryCalls++;
    if (failure) {
      return const Result.failure(CacheFailure(message: 'تعذّر التحميل'));
    }
    return Result.success(categories);
  }

  @override
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

class _FakeCustomAzkarRepository implements CustomAzkarRepository {
  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => const Result.success(null);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async => const Result.success(null);
}
