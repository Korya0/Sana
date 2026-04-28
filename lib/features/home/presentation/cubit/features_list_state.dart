part of 'features_list_cubit.dart';

sealed class FeaturesListState {
  const FeaturesListState();
}

final class FeaturesListInitial extends FeaturesListState {
  const FeaturesListInitial();
}

final class FeaturesListLoading extends FeaturesListState {
  const FeaturesListLoading();
}

final class FeaturesListLoaded extends FeaturesListState {
  const FeaturesListLoaded(this.features);
  final List<CategoryItem> features;
}

final class FeaturesListError extends FeaturesListState {
  const FeaturesListError(this.message);
  final String message;
}
