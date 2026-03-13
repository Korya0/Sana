// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReminderState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ReminderSettings settings) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ReminderSettings settings)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ReminderSettings settings)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReminderInitial value) initial,
    required TResult Function(ReminderLoading value) loading,
    required TResult Function(ReminderLoaded value) loaded,
    required TResult Function(ReminderError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReminderInitial value)? initial,
    TResult? Function(ReminderLoading value)? loading,
    TResult? Function(ReminderLoaded value)? loaded,
    TResult? Function(ReminderError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReminderInitial value)? initial,
    TResult Function(ReminderLoading value)? loading,
    TResult Function(ReminderLoaded value)? loaded,
    TResult Function(ReminderError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderStateCopyWith<$Res> {
  factory $ReminderStateCopyWith(
    ReminderState value,
    $Res Function(ReminderState) then,
  ) = _$ReminderStateCopyWithImpl<$Res, ReminderState>;
}

/// @nodoc
class _$ReminderStateCopyWithImpl<$Res, $Val extends ReminderState>
    implements $ReminderStateCopyWith<$Res> {
  _$ReminderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ReminderInitialImplCopyWith<$Res> {
  factory _$$ReminderInitialImplCopyWith(
    _$ReminderInitialImpl value,
    $Res Function(_$ReminderInitialImpl) then,
  ) = __$$ReminderInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReminderInitialImplCopyWithImpl<$Res>
    extends _$ReminderStateCopyWithImpl<$Res, _$ReminderInitialImpl>
    implements _$$ReminderInitialImplCopyWith<$Res> {
  __$$ReminderInitialImplCopyWithImpl(
    _$ReminderInitialImpl _value,
    $Res Function(_$ReminderInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ReminderInitialImpl implements ReminderInitial {
  const _$ReminderInitialImpl();

  @override
  String toString() {
    return 'ReminderState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ReminderInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ReminderSettings settings) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ReminderSettings settings)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ReminderSettings settings)? loaded,
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
    required TResult Function(ReminderInitial value) initial,
    required TResult Function(ReminderLoading value) loading,
    required TResult Function(ReminderLoaded value) loaded,
    required TResult Function(ReminderError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReminderInitial value)? initial,
    TResult? Function(ReminderLoading value)? loading,
    TResult? Function(ReminderLoaded value)? loaded,
    TResult? Function(ReminderError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReminderInitial value)? initial,
    TResult Function(ReminderLoading value)? loading,
    TResult Function(ReminderLoaded value)? loaded,
    TResult Function(ReminderError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ReminderInitial implements ReminderState {
  const factory ReminderInitial() = _$ReminderInitialImpl;
}

/// @nodoc
abstract class _$$ReminderLoadingImplCopyWith<$Res> {
  factory _$$ReminderLoadingImplCopyWith(
    _$ReminderLoadingImpl value,
    $Res Function(_$ReminderLoadingImpl) then,
  ) = __$$ReminderLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReminderLoadingImplCopyWithImpl<$Res>
    extends _$ReminderStateCopyWithImpl<$Res, _$ReminderLoadingImpl>
    implements _$$ReminderLoadingImplCopyWith<$Res> {
  __$$ReminderLoadingImplCopyWithImpl(
    _$ReminderLoadingImpl _value,
    $Res Function(_$ReminderLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ReminderLoadingImpl implements ReminderLoading {
  const _$ReminderLoadingImpl();

  @override
  String toString() {
    return 'ReminderState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ReminderLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ReminderSettings settings) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ReminderSettings settings)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ReminderSettings settings)? loaded,
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
    required TResult Function(ReminderInitial value) initial,
    required TResult Function(ReminderLoading value) loading,
    required TResult Function(ReminderLoaded value) loaded,
    required TResult Function(ReminderError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReminderInitial value)? initial,
    TResult? Function(ReminderLoading value)? loading,
    TResult? Function(ReminderLoaded value)? loaded,
    TResult? Function(ReminderError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReminderInitial value)? initial,
    TResult Function(ReminderLoading value)? loading,
    TResult Function(ReminderLoaded value)? loaded,
    TResult Function(ReminderError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ReminderLoading implements ReminderState {
  const factory ReminderLoading() = _$ReminderLoadingImpl;
}

/// @nodoc
abstract class _$$ReminderLoadedImplCopyWith<$Res> {
  factory _$$ReminderLoadedImplCopyWith(
    _$ReminderLoadedImpl value,
    $Res Function(_$ReminderLoadedImpl) then,
  ) = __$$ReminderLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ReminderSettings settings});

  $ReminderSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$ReminderLoadedImplCopyWithImpl<$Res>
    extends _$ReminderStateCopyWithImpl<$Res, _$ReminderLoadedImpl>
    implements _$$ReminderLoadedImplCopyWith<$Res> {
  __$$ReminderLoadedImplCopyWithImpl(
    _$ReminderLoadedImpl _value,
    $Res Function(_$ReminderLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null}) {
    return _then(
      _$ReminderLoadedImpl(
        null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as ReminderSettings,
      ),
    );
  }

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReminderSettingsCopyWith<$Res> get settings {
    return $ReminderSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value));
    });
  }
}

/// @nodoc

class _$ReminderLoadedImpl implements ReminderLoaded {
  const _$ReminderLoadedImpl(this.settings);

  @override
  final ReminderSettings settings;

  @override
  String toString() {
    return 'ReminderState.loaded(settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderLoadedImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settings);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderLoadedImplCopyWith<_$ReminderLoadedImpl> get copyWith =>
      __$$ReminderLoadedImplCopyWithImpl<_$ReminderLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ReminderSettings settings) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(settings);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ReminderSettings settings)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(settings);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ReminderSettings settings)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(settings);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReminderInitial value) initial,
    required TResult Function(ReminderLoading value) loading,
    required TResult Function(ReminderLoaded value) loaded,
    required TResult Function(ReminderError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReminderInitial value)? initial,
    TResult? Function(ReminderLoading value)? loading,
    TResult? Function(ReminderLoaded value)? loaded,
    TResult? Function(ReminderError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReminderInitial value)? initial,
    TResult Function(ReminderLoading value)? loading,
    TResult Function(ReminderLoaded value)? loaded,
    TResult Function(ReminderError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ReminderLoaded implements ReminderState {
  const factory ReminderLoaded(final ReminderSettings settings) =
      _$ReminderLoadedImpl;

  ReminderSettings get settings;

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderLoadedImplCopyWith<_$ReminderLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReminderErrorImplCopyWith<$Res> {
  factory _$$ReminderErrorImplCopyWith(
    _$ReminderErrorImpl value,
    $Res Function(_$ReminderErrorImpl) then,
  ) = __$$ReminderErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ReminderErrorImplCopyWithImpl<$Res>
    extends _$ReminderStateCopyWithImpl<$Res, _$ReminderErrorImpl>
    implements _$$ReminderErrorImplCopyWith<$Res> {
  __$$ReminderErrorImplCopyWithImpl(
    _$ReminderErrorImpl _value,
    $Res Function(_$ReminderErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ReminderErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ReminderErrorImpl implements ReminderError {
  const _$ReminderErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ReminderState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderErrorImplCopyWith<_$ReminderErrorImpl> get copyWith =>
      __$$ReminderErrorImplCopyWithImpl<_$ReminderErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ReminderSettings settings) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ReminderSettings settings)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ReminderSettings settings)? loaded,
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
    required TResult Function(ReminderInitial value) initial,
    required TResult Function(ReminderLoading value) loading,
    required TResult Function(ReminderLoaded value) loaded,
    required TResult Function(ReminderError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReminderInitial value)? initial,
    TResult? Function(ReminderLoading value)? loading,
    TResult? Function(ReminderLoaded value)? loaded,
    TResult? Function(ReminderError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReminderInitial value)? initial,
    TResult Function(ReminderLoading value)? loading,
    TResult Function(ReminderLoaded value)? loaded,
    TResult Function(ReminderError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ReminderError implements ReminderState {
  const factory ReminderError(final String message) = _$ReminderErrorImpl;

  String get message;

  /// Create a copy of ReminderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderErrorImplCopyWith<_$ReminderErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
