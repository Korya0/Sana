import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/repos/azkar_repository.dart';

part 'azkar_category_loader_cubit.freezed.dart';

// --- State ---
@freezed
class AzkarCategoryLoaderState with _$AzkarCategoryLoaderState {
  const factory AzkarCategoryLoaderState.initial() = AzkarCategoryLoaderInitial;
  const factory AzkarCategoryLoaderState.loading() = AzkarCategoryLoaderLoading;
  const factory AzkarCategoryLoaderState.loaded(AzkarCategoryModel category) =
      AzkarCategoryLoaderLoaded;
  const factory AzkarCategoryLoaderState.error(String message) =
      AzkarCategoryLoaderError;
}

// --- Cubit ---
class AzkarCategoryLoaderCubit extends Cubit<AzkarCategoryLoaderState> {
  AzkarCategoryLoaderCubit(this._repository)
    : super(const AzkarCategoryLoaderState.initial());
  final IAzkarRepository _repository;

  Future<void> loadCategory(String id) async {
    if (id.isEmpty) {
      emit(const AzkarCategoryLoaderState.error('Invalid Category ID'));
      return;
    }

    emit(const AzkarCategoryLoaderState.loading());

    final result = await _repository.getItemById(id);
    result.when(
      success: (category) => emit(AzkarCategoryLoaderState.loaded(category)),
      failure: (failure) =>
          emit(AzkarCategoryLoaderState.error(failure.message)),
    );
  }
}
