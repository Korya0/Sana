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
  const FeaturesListLoaded(this.features);
  final List<CategoryItem> features;
  @override
  List<Object?> get props => [features];
}

class FeaturesListError extends FeaturesListState {
  const FeaturesListError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// --- Cubit ---
class FeaturesListCubit extends Cubit<FeaturesListState> {
  FeaturesListCubit(this._repository) : super(FeaturesListInitial());
  final IFeaturesRepository _repository;

  void loadFeatures() {
    emit(FeaturesListLoading());
    try {
      final items = _repository.getFeatures();
      emit(FeaturesListLoaded(items));
    } on Exception catch (e) {
      emit(FeaturesListError(e.toString()));
    }
  }
}
