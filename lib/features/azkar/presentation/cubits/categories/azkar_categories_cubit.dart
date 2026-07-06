import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit(this._getCategoriesUseCase)
    : super(AzkarCategoriesInitial());

  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> loadCategories() async {
    emit(AzkarCategoriesLoading());

    final result = await _getCategoriesUseCase();

    if (result is Success<List<CategoryEntity>>) {
      final categories = result.data;
      if (categories.isEmpty) {
        emit(AzkarCategoriesEmpty());
      } else {
        emit(AzkarCategoriesLoaded(categories));
      }
    } else if (result is FailureResult<List<CategoryEntity>>) {
      emit(AzkarCategoriesError(result.failure.message));
    }
  }
}
