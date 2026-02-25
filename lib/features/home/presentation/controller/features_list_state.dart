part of 'features_list_cubit.dart';

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
