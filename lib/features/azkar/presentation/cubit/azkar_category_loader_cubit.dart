import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sana/features/azkar/data/repos/azkar_repository.dart';
import 'package:sana/core/networking/result.dart';

import 'package:sana/features/azkar/presentation/cubit/azkar_category_loader_state.dart';

// --- Cubit ---
class AzkarCategoryLoaderCubit extends Cubit<AzkarCategoryLoaderState> {
  AzkarCategoryLoaderCubit(this._repository)
    : super(const AzkarCategoryLoaderInitial());
  final IAzkarRepository _repository;

  Future<void> loadCategory(String id) async {
    if (id.isEmpty) {
      emit(const AzkarCategoryLoaderError('Invalid Category ID'));
      return;
    }

    emit(const AzkarCategoryLoaderLoading());

    final result = await _repository.getItemById(id);
    switch (result) {
      case Success(data: final item):
        emit(AzkarCategoryLoaderLoaded(item));
      case FailureResult(:final failure):
        emit(AzkarCategoryLoaderError(failure.message));
    }
  }
}
