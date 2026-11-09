import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/get_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit(
    this._getCategoriesUseCase,
    this._getCustomCategoriesUseCase,
  ) : super(AzkarCategoriesInitial());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetCustomCategoriesUseCase _getCustomCategoriesUseCase;

  // Loads all categories with custom categories having priority
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
            .where((c) => !c.id.startsWith('custom_'))
            .map((c) => c.id)
            .toSet();

        final customCategories = customList
            .where((c) => c.id.startsWith('custom_'))
            .map((c) => c.toCategoryEntity())
            .toList();

        final updatedStandardCategories = standardCategories.map((c) {
          if (modifiedBuiltInKeys.contains(c.key)) {
            return c.copyWith(isCustom: true);
          }
          return c;
        }).toList();

        final List<CategoryEntity> allCategories = [
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
