import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository.dart';

// --- State ---
abstract class AzkarCategoryLoaderState extends Equatable {
  const AzkarCategoryLoaderState();

  @override
  List<Object?> get props => [];
}

class AzkarCategoryLoaderInitial extends AzkarCategoryLoaderState {}

class AzkarCategoryLoaderLoading extends AzkarCategoryLoaderState {}

class AzkarCategoryLoaderLoaded extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderLoaded(this.category);
  final AzkarCategoryModel category;

  @override
  List<Object?> get props => [category];
}

class AzkarCategoryLoaderError extends AzkarCategoryLoaderState {
  const AzkarCategoryLoaderError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// --- Cubit ---
class AzkarCategoryLoaderCubit extends Cubit<AzkarCategoryLoaderState> {
  AzkarCategoryLoaderCubit(this._repository)
    : super(AzkarCategoryLoaderInitial());
  final IAzkarRepository _repository;

  Future<void> loadCategory(String id) async {
    if (id.isEmpty) {
      emit(const AzkarCategoryLoaderError('Invalid Category ID'));
      return;
    }

    emit(AzkarCategoryLoaderLoading());

    try {
      final category = await _repository.getItemById(id);
      if (category != null) {
        emit(AzkarCategoryLoaderLoaded(category));
      } else {
        emit(const AzkarCategoryLoaderError('Category not found'));
      }
    } on Exception catch (e) {
      emit(AzkarCategoryLoaderError(e.toString()));
    }
  }
}
