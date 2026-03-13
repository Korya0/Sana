import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository.dart';

part 'azkar_categories_cubit.freezed.dart';

@freezed
class AzkarCategoriesState with _$AzkarCategoriesState {
  const factory AzkarCategoriesState.initial() = AzkarCategoriesInitial;
  const factory AzkarCategoriesState.loading() = AzkarCategoriesLoading;
  const factory AzkarCategoriesState.loaded(
    List<AzkarCategoryModel> azkarCategories,
  ) = AzkarCategoriesLoaded;
  const factory AzkarCategoriesState.error(String message) =
      AzkarCategoriesError;
}

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit(this._repository)
    : super(const AzkarCategoriesState.initial()) {
    unawaited(loadAzkar());
  }

  final IAzkarRepository _repository;

  Future<void> loadAzkar() async {
    emit(const AzkarCategoriesState.loading());
    final result = await _repository.getAllCategories();
    result.when(
      success: (items) => emit(AzkarCategoriesState.loaded(items)),
      failure: (failure) => emit(AzkarCategoriesState.error(failure.message)),
    );
  }
}
