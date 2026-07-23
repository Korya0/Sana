import 'package:flutter/foundation.dart';
import 'package:sana/core/error/error.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = FailureResult<T>;
}

@immutable
class Success<T> extends Result<T> {
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

@immutable
class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FailureResult<T> && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;
}
