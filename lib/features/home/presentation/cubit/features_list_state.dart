part of 'features_list_cubit.dart';

@freezed
class FeaturesListState with _$FeaturesListState {
  const factory FeaturesListState.initial() = FeaturesListInitial;
  const factory FeaturesListState.loading() = FeaturesListLoading;
  const factory FeaturesListState.loaded(List<CategoryItem> features) =
      FeaturesListLoaded;
  const factory FeaturesListState.error(String message) = FeaturesListError;
}
