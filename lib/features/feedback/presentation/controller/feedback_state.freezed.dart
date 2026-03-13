// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FeedbackState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sending,
    required TResult Function(String message) success,
    required TResult Function(String error) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sending,
    TResult? Function(String message)? success,
    TResult? Function(String error)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sending,
    TResult Function(String message)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackInitial value) initial,
    required TResult Function(FeedbackSending value) sending,
    required TResult Function(FeedbackSuccess value) success,
    required TResult Function(FeedbackFailure value) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackInitial value)? initial,
    TResult? Function(FeedbackSending value)? sending,
    TResult? Function(FeedbackSuccess value)? success,
    TResult? Function(FeedbackFailure value)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackInitial value)? initial,
    TResult Function(FeedbackSending value)? sending,
    TResult Function(FeedbackSuccess value)? success,
    TResult Function(FeedbackFailure value)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackStateCopyWith<$Res> {
  factory $FeedbackStateCopyWith(
    FeedbackState value,
    $Res Function(FeedbackState) then,
  ) = _$FeedbackStateCopyWithImpl<$Res, FeedbackState>;
}

/// @nodoc
class _$FeedbackStateCopyWithImpl<$Res, $Val extends FeedbackState>
    implements $FeedbackStateCopyWith<$Res> {
  _$FeedbackStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FeedbackInitialImplCopyWith<$Res> {
  factory _$$FeedbackInitialImplCopyWith(
    _$FeedbackInitialImpl value,
    $Res Function(_$FeedbackInitialImpl) then,
  ) = __$$FeedbackInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FeedbackInitialImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackInitialImpl>
    implements _$$FeedbackInitialImplCopyWith<$Res> {
  __$$FeedbackInitialImplCopyWithImpl(
    _$FeedbackInitialImpl _value,
    $Res Function(_$FeedbackInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FeedbackInitialImpl implements FeedbackInitial {
  const _$FeedbackInitialImpl();

  @override
  String toString() {
    return 'FeedbackState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FeedbackInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sending,
    required TResult Function(String message) success,
    required TResult Function(String error) failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sending,
    TResult? Function(String message)? success,
    TResult? Function(String error)? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sending,
    TResult Function(String message)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackInitial value) initial,
    required TResult Function(FeedbackSending value) sending,
    required TResult Function(FeedbackSuccess value) success,
    required TResult Function(FeedbackFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackInitial value)? initial,
    TResult? Function(FeedbackSending value)? sending,
    TResult? Function(FeedbackSuccess value)? success,
    TResult? Function(FeedbackFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackInitial value)? initial,
    TResult Function(FeedbackSending value)? sending,
    TResult Function(FeedbackSuccess value)? success,
    TResult Function(FeedbackFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class FeedbackInitial implements FeedbackState {
  const factory FeedbackInitial() = _$FeedbackInitialImpl;
}

/// @nodoc
abstract class _$$FeedbackSendingImplCopyWith<$Res> {
  factory _$$FeedbackSendingImplCopyWith(
    _$FeedbackSendingImpl value,
    $Res Function(_$FeedbackSendingImpl) then,
  ) = __$$FeedbackSendingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FeedbackSendingImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackSendingImpl>
    implements _$$FeedbackSendingImplCopyWith<$Res> {
  __$$FeedbackSendingImplCopyWithImpl(
    _$FeedbackSendingImpl _value,
    $Res Function(_$FeedbackSendingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FeedbackSendingImpl implements FeedbackSending {
  const _$FeedbackSendingImpl();

  @override
  String toString() {
    return 'FeedbackState.sending()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FeedbackSendingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sending,
    required TResult Function(String message) success,
    required TResult Function(String error) failure,
  }) {
    return sending();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sending,
    TResult? Function(String message)? success,
    TResult? Function(String error)? failure,
  }) {
    return sending?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sending,
    TResult Function(String message)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (sending != null) {
      return sending();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackInitial value) initial,
    required TResult Function(FeedbackSending value) sending,
    required TResult Function(FeedbackSuccess value) success,
    required TResult Function(FeedbackFailure value) failure,
  }) {
    return sending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackInitial value)? initial,
    TResult? Function(FeedbackSending value)? sending,
    TResult? Function(FeedbackSuccess value)? success,
    TResult? Function(FeedbackFailure value)? failure,
  }) {
    return sending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackInitial value)? initial,
    TResult Function(FeedbackSending value)? sending,
    TResult Function(FeedbackSuccess value)? success,
    TResult Function(FeedbackFailure value)? failure,
    required TResult orElse(),
  }) {
    if (sending != null) {
      return sending(this);
    }
    return orElse();
  }
}

abstract class FeedbackSending implements FeedbackState {
  const factory FeedbackSending() = _$FeedbackSendingImpl;
}

/// @nodoc
abstract class _$$FeedbackSuccessImplCopyWith<$Res> {
  factory _$$FeedbackSuccessImplCopyWith(
    _$FeedbackSuccessImpl value,
    $Res Function(_$FeedbackSuccessImpl) then,
  ) = __$$FeedbackSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FeedbackSuccessImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackSuccessImpl>
    implements _$$FeedbackSuccessImplCopyWith<$Res> {
  __$$FeedbackSuccessImplCopyWithImpl(
    _$FeedbackSuccessImpl _value,
    $Res Function(_$FeedbackSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FeedbackSuccessImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FeedbackSuccessImpl implements FeedbackSuccess {
  const _$FeedbackSuccessImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'FeedbackState.success(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackSuccessImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackSuccessImplCopyWith<_$FeedbackSuccessImpl> get copyWith =>
      __$$FeedbackSuccessImplCopyWithImpl<_$FeedbackSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sending,
    required TResult Function(String message) success,
    required TResult Function(String error) failure,
  }) {
    return success(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sending,
    TResult? Function(String message)? success,
    TResult? Function(String error)? failure,
  }) {
    return success?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sending,
    TResult Function(String message)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackInitial value) initial,
    required TResult Function(FeedbackSending value) sending,
    required TResult Function(FeedbackSuccess value) success,
    required TResult Function(FeedbackFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackInitial value)? initial,
    TResult? Function(FeedbackSending value)? sending,
    TResult? Function(FeedbackSuccess value)? success,
    TResult? Function(FeedbackFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackInitial value)? initial,
    TResult Function(FeedbackSending value)? sending,
    TResult Function(FeedbackSuccess value)? success,
    TResult Function(FeedbackFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class FeedbackSuccess implements FeedbackState {
  const factory FeedbackSuccess({required final String message}) =
      _$FeedbackSuccessImpl;

  String get message;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackSuccessImplCopyWith<_$FeedbackSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FeedbackFailureImplCopyWith<$Res> {
  factory _$$FeedbackFailureImplCopyWith(
    _$FeedbackFailureImpl value,
    $Res Function(_$FeedbackFailureImpl) then,
  ) = __$$FeedbackFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$FeedbackFailureImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackFailureImpl>
    implements _$$FeedbackFailureImplCopyWith<$Res> {
  __$$FeedbackFailureImplCopyWithImpl(
    _$FeedbackFailureImpl _value,
    $Res Function(_$FeedbackFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$FeedbackFailureImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FeedbackFailureImpl implements FeedbackFailure {
  const _$FeedbackFailureImpl({required this.error});

  @override
  final String error;

  @override
  String toString() {
    return 'FeedbackState.failure(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackFailureImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackFailureImplCopyWith<_$FeedbackFailureImpl> get copyWith =>
      __$$FeedbackFailureImplCopyWithImpl<_$FeedbackFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() sending,
    required TResult Function(String message) success,
    required TResult Function(String error) failure,
  }) {
    return failure(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? sending,
    TResult? Function(String message)? success,
    TResult? Function(String error)? failure,
  }) {
    return failure?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? sending,
    TResult Function(String message)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackInitial value) initial,
    required TResult Function(FeedbackSending value) sending,
    required TResult Function(FeedbackSuccess value) success,
    required TResult Function(FeedbackFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackInitial value)? initial,
    TResult? Function(FeedbackSending value)? sending,
    TResult? Function(FeedbackSuccess value)? success,
    TResult? Function(FeedbackFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackInitial value)? initial,
    TResult Function(FeedbackSending value)? sending,
    TResult Function(FeedbackSuccess value)? success,
    TResult Function(FeedbackFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class FeedbackFailure implements FeedbackState {
  const factory FeedbackFailure({required final String error}) =
      _$FeedbackFailureImpl;

  String get error;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackFailureImplCopyWith<_$FeedbackFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
