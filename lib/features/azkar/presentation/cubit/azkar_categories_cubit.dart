import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sana/features/azkar/data/repos/azkar_repository.dart';
import 'package:sana/core/networking/result.dart';

import 'package:sana/features/azkar/presentation/cubit/azkar_categories_state.dart';

class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit(this._repository)
    : super(const AzkarCategoriesInitial());

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
