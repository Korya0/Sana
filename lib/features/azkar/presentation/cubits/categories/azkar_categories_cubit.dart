import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/extensions/custom_category_id_extension.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  // Creates cubit
  AzkarCategoriesCubit(
    this._getCategoriesUseCase,
    this._getCustomCategoriesUseCase,
    this._getZikrsByCategoryUseCase,
  ) : super(AzkarCategoriesInitial());

  final GetAzkarCategoriesUseCase _getCategoriesUseCase;
  final GetCustomCategoriesUseCase _getCustomCategoriesUseCase;
  final GetZikrsByCategoryUseCase _getZikrsByCategoryUseCase;

  // Loads azkar for a category
  Future<Result<List<ZikrEntity>>> getAzkarForCategory(String key) =>
      _getZikrsByCategoryUseCase(key);

  // Loads categories
  Future<void> loadCategories() async {
    emit(AzkarCategoriesLoading());

    final customResult = await _getCustomCategoriesUseCase();
    final categoriesResult = await _getCategoriesUseCase();
    if (isClosed) return;

    switch (categoriesResult) {
      case Success(data: final standardCategories):
        final List<CustomCategoryEntity> customList = switch (customResult) {
          Success(data: final list) => list,
          _ => const [],
        };

        final modifiedBuiltInKeys = customList
            .where((c) => !c.id.isCustomCategoryId)
            .map((c) => c.id)
            .toSet();

        final customCategories = customList
            .where((c) => c.id.isCustomCategoryId)
            .map((c) => c.toCategoryEntity())
            .toList();

        // Built-in names remain app-owned for overrides.
        final updatedStandardCategories = standardCategories.map((c) {
          if (modifiedBuiltInKeys.contains(c.key)) {
            return c.copyWith(isModified: true);
          }
          return c;
        }).toList();

        final List<AzkarCategoryEntity> allCategories = [
          ...customCategories,
          ...updatedStandardCategories,
        ];
        if (allCategories.isEmpty) {
          emit(AzkarCategoriesEmpty());
        } else {
          emit(AzkarCategoriesLoaded(allCategories));
        }
      case FailureResult(:final failure):
        emit(AzkarCategoriesError(failure.message));
    }
  }
}
