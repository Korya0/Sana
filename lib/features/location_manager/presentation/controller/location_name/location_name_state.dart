part of 'location_name_cubit.dart';

@freezed
class LocationNameState with _$LocationNameState {
  const factory LocationNameState.initial() = LocationNameInitial;
  const factory LocationNameState.loading() = LocationNameLoading;
  const factory LocationNameState.loaded(String location) = LocationNameLoaded;
  const factory LocationNameState.error(String message) = LocationNameError;
}
