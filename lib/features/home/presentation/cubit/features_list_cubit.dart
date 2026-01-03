import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/data/repositories/features_repository.dart';

// --- State ---
abstract class FeaturesListState extends Equatable {
  const FeaturesListState();
  @override
  List<Object?> get props => [];
}

class FeaturesListInitial extends FeaturesListState {}

class FeaturesListLoading extends FeaturesListState {}

class FeaturesListLoaded extends FeaturesListState {
  final List<CategoryItem> features;
  const FeaturesListLoaded(this.features);
  @override
  List<Object?> get props => [features];
}

class FeaturesListError extends FeaturesListState {
  final String message;
  const FeaturesListError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Cubit ---
class FeaturesListCubit extends Cubit<FeaturesListState> {
  final IFeaturesRepository _repository;

  FeaturesListCubit(this._repository) : super(FeaturesListInitial());

  void loadFeatures() {
    emit(FeaturesListLoading());
    try {
      final items = _repository.getFeatures();
      emit(FeaturesListLoaded(items));
    } catch (e) {
      emit(FeaturesListError(e.toString()));
    }
  }
}
