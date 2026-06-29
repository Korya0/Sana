//
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
import 'package:sana/core/error/error.dart';

sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = ApiFailure<T>;

  // Note: Use native Dart 3 'switch' expressions for exhaustive pattern matching
  // instead of these legacy helper methods.
}

class Success<T> extends ApiResult<T> {
  const Success(this.data);
  final T data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.failure);
  final Failure failure;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiFailure<T> && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;
}
