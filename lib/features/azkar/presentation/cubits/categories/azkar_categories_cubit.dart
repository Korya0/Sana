import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/use_cases/get_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit(this._getCategoriesUseCase)
    : super(AzkarCategoriesInitial());

  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> loadCategories() async {
    emit(AzkarCategoriesLoading());

    final result = await _getCategoriesUseCase();
    if (isClosed) return;

    switch (result) {
      case Success(data: final categories):
        if (categories.isEmpty) {
          emit(AzkarCategoriesEmpty());
        } else {
          emit(AzkarCategoriesLoaded(categories));
        }
      case FailureResult(:final failure):
        emit(AzkarCategoriesError(failure.message));
    }
  }
}
