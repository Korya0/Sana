import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const Failure._();

  const factory Failure.server({required String message, int? statusCode}) =
      ServerFailure;
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.location({required String message}) = LocationFailure;
  const factory Failure.sensor({required String message}) = SensorFailure;
  const factory Failure.missingData({required String message}) =
      MissingDataFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;

  // No need for a custom getter if we use pattern matching or if we want to expose it
  // But for Freezed to allow a common property, it must be present in all constructors.
  // It is already present in all constructors above.
}
