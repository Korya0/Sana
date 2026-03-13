part of 'location_cubit.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState.initial() = LocationInitial;
  const factory LocationState.loading() = LocationLoading;
  const factory LocationState.success({
    @Default(AppStrings.success) String message,
  }) = LocationSuccess;
  const factory LocationState.needsServiceEnable({
    @Default(AppStrings.needsLocationService) String message,
  }) = LocationNeedsServiceEnable;
  const factory LocationState.needsPermission({
    @Default(AppStrings.needsLocationPermission) String message,
  }) = LocationNeedsPermission;
  const factory LocationState.disabled({
    @Default(AppStrings.locationDisabled) String message,
  }) = LocationDisabled;
  const factory LocationState.permissionDenied({
    @Default(AppStrings.locationPermissionDenied) String message,
  }) = LocationPermissionDenied;
  const factory LocationState.error({required String message}) = LocationError;
  const factory LocationState.permissionPermanentlyDenied() =
      LocationPermissionPermanentlyDenied;
}
