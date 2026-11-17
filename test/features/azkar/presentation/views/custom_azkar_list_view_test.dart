import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/views/custom_azkar_list_view.dart';

void main() {
  late _FakeCustomCategoryRepository repository;

  setUp(() {
    repository = _FakeCustomCategoryRepository();

    sl.registerFactory<CustomAzkarCubit>(
      () => CustomAzkarCubit(
        getCustomCategoriesUseCase: GetCustomCategoriesUseCase(repository),
        saveCustomCategoryUseCase: SaveCustomCategoryUseCase(repository),
        deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(repository),
        getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(
          const _EmptyAzkarRepository(),
        ),
      ),
    );
  });

  tearDown(() async => sl.reset());

  testWidgets('shows the empty state when nothing is customised', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.noCustomAzkarYet), findsOneWidget);
  });

  testWidgets('shows each custom or modified category', (tester) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'custom_1',
        name: 'أذكاري',
        azkar: [
          ZikrEntity(id: 1, text: 'سبحان الله', count: 3),
          ZikrEntity(id: 2, text: 'الحمد لله', count: 3),
        ],
      ),
      CustomCategoryEntity(
        id: 'morning',
        name: 'الصباح',
        azkar: [ZikrEntity(id: 3, text: 'ذكر', count: 3)],
      ),
    ];

    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text('أذكاري'), findsOneWidget);
    expect(find.text(AppStrings.azkarCountLabel(2)), findsOneWidget);
    expect(find.text('الصباح'), findsOneWidget);
    // Both a custom category and a built-in override can be edited.
    expect(find.byIcon(AppIcons.edit), findsNWidgets(2));
    expect(find.byIcon(AppIcons.delete), findsOneWidget);
    expect(find.byIcon(AppIcons.refresh), findsOneWidget);
  });

  testWidgets('a failed restore shows an error toast', (tester) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'morning',
        name: 'الصباح',
        azkar: [ZikrEntity(id: 3, text: 'ذكر', count: 3)],
      ),
    ];
    repository.deleteFailure = true;

    await _pump(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.refresh));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(AppPrimaryButton, AppStrings.restoreOriginal),
    );
    await tester.pumpAndSettle();

    // The error view and the toast both carry the failure message.
    expect(find.text('تعذّر حذف القسم'), findsNWidgets(2));

    // Let the toast timer finish so the test leaves no pending timers.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('deleting a category asks for confirmation and removes it', (
    tester,
  ) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'custom_1',
        name: 'أذكاري',
        azkar: [ZikrEntity(id: 1, text: 'سبحان الله', count: 3)],
      ),
    ];
    await _pump(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deleteCustomAzkarDialogTitle), findsOneWidget);

    await tester.tap(find.widgetWithText(AppPrimaryButton, AppStrings.delete));
    await tester.pumpAndSettle();

    expect(repository.deleteCalls, 1);
    expect(find.text(AppStrings.noCustomAzkarYet), findsOneWidget);

    // Let the success toast timer finish so the test leaves no pending timers.
    await tester.pump(const Duration(seconds: 3));
  });
}

Future<void> _pump(WidgetTester tester) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(textDirection: TextDirection.rtl, child: child!);
    },
    home: const CustomAzkarListView(),
  ),
);

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  List<CustomCategoryEntity> categories = const [];
  int deleteCalls = 0;
  bool deleteFailure = false;

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    deleteCalls++;
    if (deleteFailure) {
      return const Result.failure(
        CacheFailure(message: 'تعذّر حذف القسم'),
      );
    }
    categories = categories.where((category) => category.id != id).toList();
    return const Result.success(null);
  }

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async {
    for (final category in categories) {
      if (category.id == id) return Result.success(category);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      Result.success(categories);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async {
    categories = [
      ...categories.where((item) => item.id != category.id),
      category,
    ];
    return const Result.success(null);
  }
}

class _EmptyAzkarRepository implements AzkarRepository {
  const _EmptyAzkarRepository();

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([]);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}
