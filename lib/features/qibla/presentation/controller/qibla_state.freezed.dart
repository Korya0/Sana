// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qibla_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QiblaState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(double qiblaDirection, double distanceToKaaba)
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QiblaInitial value) initial,
    required TResult Function(QiblaLoading value) loading,
    required TResult Function(QiblaLoaded value) loaded,
    required TResult Function(QiblaError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QiblaInitial value)? initial,
    TResult? Function(QiblaLoading value)? loading,
    TResult? Function(QiblaLoaded value)? loaded,
    TResult? Function(QiblaError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QiblaInitial value)? initial,
    TResult Function(QiblaLoading value)? loading,
    TResult Function(QiblaLoaded value)? loaded,
    TResult Function(QiblaError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QiblaStateCopyWith<$Res> {
  factory $QiblaStateCopyWith(
    QiblaState value,
    $Res Function(QiblaState) then,
  ) = _$QiblaStateCopyWithImpl<$Res, QiblaState>;
}

/// @nodoc
class _$QiblaStateCopyWithImpl<$Res, $Val extends QiblaState>
    implements $QiblaStateCopyWith<$Res> {
  _$QiblaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$QiblaInitialImplCopyWith<$Res> {
  factory _$$QiblaInitialImplCopyWith(
    _$QiblaInitialImpl value,
    $Res Function(_$QiblaInitialImpl) then,
  ) = __$$QiblaInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$QiblaInitialImplCopyWithImpl<$Res>
    extends _$QiblaStateCopyWithImpl<$Res, _$QiblaInitialImpl>
    implements _$$QiblaInitialImplCopyWith<$Res> {
  __$$QiblaInitialImplCopyWithImpl(
    _$QiblaInitialImpl _value,
    $Res Function(_$QiblaInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$QiblaInitialImpl implements QiblaInitial {
  const _$QiblaInitialImpl();

  @override
  String toString() {
    return 'QiblaState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$QiblaInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(double qiblaDirection, double distanceToKaaba)
    loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult Function(String message)? error,
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
    required TResult Function(QiblaInitial value) initial,
    required TResult Function(QiblaLoading value) loading,
    required TResult Function(QiblaLoaded value) loaded,
    required TResult Function(QiblaError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QiblaInitial value)? initial,
    TResult? Function(QiblaLoading value)? loading,
    TResult? Function(QiblaLoaded value)? loaded,
    TResult? Function(QiblaError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QiblaInitial value)? initial,
    TResult Function(QiblaLoading value)? loading,
    TResult Function(QiblaLoaded value)? loaded,
    TResult Function(QiblaError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class QiblaInitial implements QiblaState {
  const factory QiblaInitial() = _$QiblaInitialImpl;
}

/// @nodoc
abstract class _$$QiblaLoadingImplCopyWith<$Res> {
  factory _$$QiblaLoadingImplCopyWith(
    _$QiblaLoadingImpl value,
    $Res Function(_$QiblaLoadingImpl) then,
  ) = __$$QiblaLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$QiblaLoadingImplCopyWithImpl<$Res>
    extends _$QiblaStateCopyWithImpl<$Res, _$QiblaLoadingImpl>
    implements _$$QiblaLoadingImplCopyWith<$Res> {
  __$$QiblaLoadingImplCopyWithImpl(
    _$QiblaLoadingImpl _value,
    $Res Function(_$QiblaLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$QiblaLoadingImpl implements QiblaLoading {
  const _$QiblaLoadingImpl();

  @override
  String toString() {
    return 'QiblaState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$QiblaLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(double qiblaDirection, double distanceToKaaba)
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QiblaInitial value) initial,
    required TResult Function(QiblaLoading value) loading,
    required TResult Function(QiblaLoaded value) loaded,
    required TResult Function(QiblaError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QiblaInitial value)? initial,
    TResult? Function(QiblaLoading value)? loading,
    TResult? Function(QiblaLoaded value)? loaded,
    TResult? Function(QiblaError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QiblaInitial value)? initial,
    TResult Function(QiblaLoading value)? loading,
    TResult Function(QiblaLoaded value)? loaded,
    TResult Function(QiblaError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class QiblaLoading implements QiblaState {
  const factory QiblaLoading() = _$QiblaLoadingImpl;
}

/// @nodoc
abstract class _$$QiblaLoadedImplCopyWith<$Res> {
  factory _$$QiblaLoadedImplCopyWith(
    _$QiblaLoadedImpl value,
    $Res Function(_$QiblaLoadedImpl) then,
  ) = __$$QiblaLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double qiblaDirection, double distanceToKaaba});
}

/// @nodoc
class __$$QiblaLoadedImplCopyWithImpl<$Res>
    extends _$QiblaStateCopyWithImpl<$Res, _$QiblaLoadedImpl>
    implements _$$QiblaLoadedImplCopyWith<$Res> {
  __$$QiblaLoadedImplCopyWithImpl(
    _$QiblaLoadedImpl _value,
    $Res Function(_$QiblaLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? qiblaDirection = null, Object? distanceToKaaba = null}) {
    return _then(
      _$QiblaLoadedImpl(
        qiblaDirection: null == qiblaDirection
            ? _value.qiblaDirection
            : qiblaDirection // ignore: cast_nullable_to_non_nullable
                  as double,
        distanceToKaaba: null == distanceToKaaba
            ? _value.distanceToKaaba
            : distanceToKaaba // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$QiblaLoadedImpl implements QiblaLoaded {
  const _$QiblaLoadedImpl({
    required this.qiblaDirection,
    required this.distanceToKaaba,
  });

  @override
  final double qiblaDirection;
  @override
  final double distanceToKaaba;

  @override
  String toString() {
    return 'QiblaState.loaded(qiblaDirection: $qiblaDirection, distanceToKaaba: $distanceToKaaba)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QiblaLoadedImpl &&
            (identical(other.qiblaDirection, qiblaDirection) ||
                other.qiblaDirection == qiblaDirection) &&
            (identical(other.distanceToKaaba, distanceToKaaba) ||
                other.distanceToKaaba == distanceToKaaba));
  }

  @override
  int get hashCode => Object.hash(runtimeType, qiblaDirection, distanceToKaaba);

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QiblaLoadedImplCopyWith<_$QiblaLoadedImpl> get copyWith =>
      __$$QiblaLoadedImplCopyWithImpl<_$QiblaLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(double qiblaDirection, double distanceToKaaba)
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(qiblaDirection, distanceToKaaba);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(qiblaDirection, distanceToKaaba);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(qiblaDirection, distanceToKaaba);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QiblaInitial value) initial,
    required TResult Function(QiblaLoading value) loading,
    required TResult Function(QiblaLoaded value) loaded,
    required TResult Function(QiblaError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QiblaInitial value)? initial,
    TResult? Function(QiblaLoading value)? loading,
    TResult? Function(QiblaLoaded value)? loaded,
    TResult? Function(QiblaError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QiblaInitial value)? initial,
    TResult Function(QiblaLoading value)? loading,
    TResult Function(QiblaLoaded value)? loaded,
    TResult Function(QiblaError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class QiblaLoaded implements QiblaState {
  const factory QiblaLoaded({
    required final double qiblaDirection,
    required final double distanceToKaaba,
  }) = _$QiblaLoadedImpl;

  double get qiblaDirection;
  double get distanceToKaaba;

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QiblaLoadedImplCopyWith<_$QiblaLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QiblaErrorImplCopyWith<$Res> {
  factory _$$QiblaErrorImplCopyWith(
    _$QiblaErrorImpl value,
    $Res Function(_$QiblaErrorImpl) then,
  ) = __$$QiblaErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$QiblaErrorImplCopyWithImpl<$Res>
    extends _$QiblaStateCopyWithImpl<$Res, _$QiblaErrorImpl>
    implements _$$QiblaErrorImplCopyWith<$Res> {
  __$$QiblaErrorImplCopyWithImpl(
    _$QiblaErrorImpl _value,
    $Res Function(_$QiblaErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$QiblaErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$QiblaErrorImpl implements QiblaError {
  const _$QiblaErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'QiblaState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QiblaErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QiblaErrorImplCopyWith<_$QiblaErrorImpl> get copyWith =>
      __$$QiblaErrorImplCopyWithImpl<_$QiblaErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(double qiblaDirection, double distanceToKaaba)
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(double qiblaDirection, double distanceToKaaba)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QiblaInitial value) initial,
    required TResult Function(QiblaLoading value) loading,
    required TResult Function(QiblaLoaded value) loaded,
    required TResult Function(QiblaError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QiblaInitial value)? initial,
    TResult? Function(QiblaLoading value)? loading,
    TResult? Function(QiblaLoaded value)? loaded,
    TResult? Function(QiblaError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QiblaInitial value)? initial,
    TResult Function(QiblaLoading value)? loading,
    TResult Function(QiblaLoaded value)? loaded,
    TResult Function(QiblaError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class QiblaError implements QiblaState {
  const factory QiblaError(final String message) = _$QiblaErrorImpl;

  String get message;

  /// Create a copy of QiblaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QiblaErrorImplCopyWith<_$QiblaErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
