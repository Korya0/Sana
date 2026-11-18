import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/extensions/custom_category_id_extension.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';

class CustomAzkarCubit extends Cubit<CustomAzkarState> {
  // Creates cubit
  CustomAzkarCubit({
    required GetCustomCategoriesUseCase getCustomCategoriesUseCase,
    required SaveCustomCategoryUseCase saveCustomCategoryUseCase,
    required DeleteCustomCategoryUseCase deleteCustomCategoryUseCase,
    required GetAzkarCategoriesUseCase getAzkarCategoriesUseCase,
  }) : _getCustomCategoriesUseCase = getCustomCategoriesUseCase,
       _saveCustomCategoryUseCase = saveCustomCategoryUseCase,
       _deleteCustomCategoryUseCase = deleteCustomCategoryUseCase,
       _getCategoriesUseCase = getAzkarCategoriesUseCase,
       super(const CustomAzkarInitial());

  final GetCustomCategoriesUseCase _getCustomCategoriesUseCase;
  final SaveCustomCategoryUseCase _saveCustomCategoryUseCase;
  final DeleteCustomCategoryUseCase _deleteCustomCategoryUseCase;
  final GetAzkarCategoriesUseCase _getCategoriesUseCase;

  // Loads categories
  Future<void> loadCustomCategories() =>
      _refreshCategories(showLoading: true, emitError: true);

  // Refreshes categories without replacing an already loaded list.
  Future<void> _refreshCategories({
    required bool showLoading,
    required bool emitError,
  }) async {
    if (showLoading) emit(const CustomAzkarLoading());

    final result = await _getCustomCategoriesUseCase();
    if (isClosed) return;

    switch (result) {
      case Success(data: final categories):
        final normalized = await _normalizeBuiltInNames(categories);
        if (isClosed) return;
        if (normalized.isEmpty) {
          emit(const CustomAzkarEmpty());
        } else {
          emit(CustomAzkarLoaded(normalized));
        }
      case FailureResult(:final failure):
        if (emitError) emit(CustomAzkarError(failure.message));
    }
  }

  // Normalizes names
  Future<List<CustomCategoryEntity>> _normalizeBuiltInNames(
    List<CustomCategoryEntity> categories,
  ) async {
    final hasBuiltInOverrides = categories.any(
      (category) => !category.id.isCustomCategoryId,
    );
    if (!hasBuiltInOverrides) return categories;

    final result = await _getCategoriesUseCase();
    if (isClosed || result is! Success<List<AzkarCategoryEntity>>) {
      return categories;
    }

    final originalNames = <String, String>{
      for (final category in result.data) category.key: category.title,
    };

    return [
      for (final category in categories)
        if (category.id.isCustomCategoryId)
          category
        else
          category.copyWith(name: originalNames[category.id] ?? category.name),
    ];
  }

  // Saves category
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async {
    final result = await _saveCustomCategoryUseCase(category);
    if (isClosed) return result;

    switch (result) {
      case Success():
        await _refreshCategories(showLoading: false, emitError: false);
      case FailureResult():
        // The caller shows the failure; keep the loaded list visible.
        break;
    }
    return result;
  }

  // Deletes category
  Future<Result<void>> deleteCustomCategory(String id) async {
    final result = await _deleteCustomCategoryUseCase(id);
    if (isClosed) return result;

    switch (result) {
      case Success():
        await _refreshCategories(showLoading: false, emitError: false);
      case FailureResult():
        // The caller shows the failure; keep the loaded list visible.
        break;
    }
    return result;
  }
}
