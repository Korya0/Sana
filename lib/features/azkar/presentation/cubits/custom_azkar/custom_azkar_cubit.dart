import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';

class CustomAzkarCubit extends Cubit<CustomAzkarState> {
  CustomAzkarCubit({
    required GetCustomCategoriesUseCase getCustomCategoriesUseCase,
    required SaveCustomCategoryUseCase saveCustomCategoryUseCase,
    required DeleteCustomCategoryUseCase deleteCustomCategoryUseCase,
  })  : _getCustomCategoriesUseCase = getCustomCategoriesUseCase,
        _saveCustomCategoryUseCase = saveCustomCategoryUseCase,
        _deleteCustomCategoryUseCase = deleteCustomCategoryUseCase,
        super(const CustomAzkarInitial());

  final GetCustomCategoriesUseCase _getCustomCategoriesUseCase;
  final SaveCustomCategoryUseCase _saveCustomCategoryUseCase;
  final DeleteCustomCategoryUseCase _deleteCustomCategoryUseCase;

  // Loads custom categories
  Future<void> loadCustomCategories() async {
    emit(const CustomAzkarLoading());

    final result = await _getCustomCategoriesUseCase();
    if (isClosed) return;

    switch (result) {
      case Success(data: final categories):
        if (categories.isEmpty) {
          emit(const CustomAzkarEmpty());
        } else {
          emit(CustomAzkarLoaded(categories));
        }
      case FailureResult(:final failure):
        emit(CustomAzkarError(failure.message));
    }
  }

  // Saves or updates custom category
  Future<bool> saveCustomCategory(CustomCategoryEntity category) async {
    emit(const CustomAzkarLoading());

    final result = await _saveCustomCategoryUseCase(category);
    if (isClosed) return false;

    switch (result) {
      case Success():
        emit(const CustomAzkarOperationSuccess(AppStrings.customZikrSavedSuccess));
        await loadCustomCategories();
        return true;
      case FailureResult(:final failure):
        emit(CustomAzkarError(failure.message));
        return false;
    }
  }

  // Deletes custom category
  Future<bool> deleteCustomCategory(String id) async {
    emit(const CustomAzkarLoading());

    final result = await _deleteCustomCategoryUseCase(id);
    if (isClosed) return false;

    switch (result) {
      case Success():
        emit(const CustomAzkarOperationSuccess(AppStrings.customZikrDeletedSuccess));
        await loadCustomCategories();
        return true;
      case FailureResult(:final failure):
        emit(CustomAzkarError(failure.message));
        return false;
    }
  }
}

