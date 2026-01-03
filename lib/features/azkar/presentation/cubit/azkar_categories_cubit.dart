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
  final List<AzkarCategoryModel> azkarCategories;
  const AzkarCategoriesLoaded(this.azkarCategories);
  @override
  List<Object?> get props => [azkarCategories];
}

class AzkarCategoriesError extends AzkarCategoriesState {
  final String message;
  const AzkarCategoriesError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Cubit ---
class AzkarCategoriesCubit extends Cubit<AzkarCategoriesState> {
  final IAzkarRepository _repository;

  AzkarCategoriesCubit(this._repository) : super(AzkarCategoriesInitial());

  Future<void> loadAzkar() async {
    emit(AzkarCategoriesLoading());
    try {
      final items = await _repository.getAllCategories();
      emit(AzkarCategoriesLoaded(items));
    } catch (e) {
      emit(AzkarCategoriesError(e.toString()));
    }
  }
}
