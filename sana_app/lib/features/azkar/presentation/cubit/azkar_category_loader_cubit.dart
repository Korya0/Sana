import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/repos/azkar_repository.dart';
import 'package:sana/core/networking/api_result.dart';

// --- State ---
sealed class AzkarCategoryLoaderState {
  const AzkarCategoryLoaderState();
}

class AzkarCategoryLoaderInitial extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderInitial();
}

class AzkarCategoryLoaderLoading extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderLoading();
}

class AzkarCategoryLoaderLoaded extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderLoaded(this.category);
  final AzkarCategoryModel category;
}

class AzkarCategoryLoaderError extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderError(this.message);
  final String message;
}

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
      case ApiFailure(:final failure):
        emit(AzkarCategoryLoaderError(failure.message));
    }
  }
}
