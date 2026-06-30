import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/repos/azkar_repository.dart';
import 'package:sana/core/networking/result.dart';

sealed class AzkarCategoriesState {
  const AzkarCategoriesState();
}

class AzkarCategoriesInitial extends AzkarCategoriesState {
  const AzkarCategoriesInitial();
}

class AzkarCategoriesLoading extends AzkarCategoriesState {
  const AzkarCategoriesLoading();
}

class AzkarCategoriesLoaded extends AzkarCategoriesState {
  const AzkarCategoriesLoaded(this.azkarCategories);
  final List<AzkarCategoryModel> azkarCategories;
}

class AzkarCategoriesError extends AzkarCategoriesState {
  const AzkarCategoriesError(this.message);
  final String message;
}

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit(this._repository)
    : super(const AzkarCategoriesInitial()) {
    unawaited(loadAzkar());
  }

  final IAzkarRepository _repository;

  Future<void> loadAzkar() async {
    emit(const AzkarCategoriesLoading());
    final result = await _repository.getAllCategories();
    switch (result) {
      case Success(data: final items):
        emit(AzkarCategoriesLoaded(items));
      case FailureResult(:final failure):
        emit(AzkarCategoriesError(failure.message));
    }
  }
}
