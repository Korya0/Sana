import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
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
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_category_list_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_list_section.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets(
    'renders one tile per category and keeps the app-bar create path',
    (
      tester,
    ) async {
      final cubit = _createCubit();
      addTearDown(cubit.close);

      await pumpAzkarSliver(
        tester,
        BlocProvider<CustomAzkarCubit>.value(
          value: cubit,
          child: const CustomAzkarListSection(
            categories: [
              CustomCategoryEntity(id: 'custom_1', name: 'أذكاري', azkar: []),
              CustomCategoryEntity(id: 'morning', name: 'الصباح', azkar: []),
            ],
          ),
        ),
      );

      expect(find.byType(CustomAzkarCategoryListTile), findsNWidgets(2));
      expect(find.text('أذكاري'), findsOneWidget);
      expect(find.text('الصباح'), findsOneWidget);
      // Built-in categories restore; custom categories delete.
      expect(find.byIcon(AppIcons.refresh), findsOneWidget);
      expect(find.byIcon(AppIcons.delete), findsOneWidget);
    },
  );
}

CustomAzkarCubit _createCubit() {
  final customRepository = _FakeCustomCategoryRepository();
  return CustomAzkarCubit(
    getCustomCategoriesUseCase: GetCustomCategoriesUseCase(customRepository),
    saveCustomCategoryUseCase: SaveCustomCategoryUseCase(customRepository),
    deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(customRepository),
    getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(
      _FakeAzkarRepository(),
    ),
  );
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
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

class _FakeAzkarRepository implements AzkarRepository {
  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([]);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}
