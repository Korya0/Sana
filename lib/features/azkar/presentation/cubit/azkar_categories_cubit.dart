import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository.dart';

// --- State ---
abstract class AzkarCategoriesState extends Equatable {
  const AzkarCategoriesState();
  @override
  List<Object?> get props => [];
}

class AzkarCategoriesInitial extends AzkarCategoriesState {}

class AzkarCategoriesLoading extends AzkarCategoriesState {}

class AzkarCategoriesLoaded extends AzkarCategoriesState {
  const AzkarCategoriesLoaded(this.azkarCategories);
  final List<AzkarCategoryModel> azkarCategories;
  @override
  List<Object?> get props => [azkarCategories];
}

class AzkarCategoriesError extends AzkarCategoriesState {
  const AzkarCategoriesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// --- Cubit ---
class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  AzkarCategoriesCubit(this._repository) : super(AzkarCategoriesInitial());
  final IAzkarRepository _repository;

  Future<void> loadAzkar() async {
    emit(AzkarCategoriesLoading());
    try {
      final items = await _repository.getAllCategories();
      emit(AzkarCategoriesLoaded(items));
    } on Exception catch (e) {
      emit(AzkarCategoriesError(e.toString()));
    }
  }
}
