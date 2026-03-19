import 'package:flutter/foundation.dart';
import 'package:sana/core/error/failure.dart';

@immutable
sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = ApiFailure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is ApiFailure<T>) {
      return failure((this as ApiFailure<T>).failure);
    }
    throw Exception('Unknown ApiResult type: $runtimeType');
  }

  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? success,
    R Function(Failure failure)? failure,
  }) {
    if (this is Success<T> && success != null) {
      return success((this as Success<T>).data);
    } else if (this is ApiFailure<T> && failure != null) {
      return failure((this as ApiFailure<T>).failure);
    }
    return orElse();
  }
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
