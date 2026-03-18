// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_update_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppUpdateState {
  String get currentVersion => throw _privateConstructorUsedError;
  UpdateConfigModel? get config => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    initial,
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    loading,
    required TResult Function(String currentVersion, UpdateConfigModel config)
    success,
    required TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )
    failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    initial,
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    loading,
    TResult? Function(String currentVersion, UpdateConfigModel config)? success,
    TResult? Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String currentVersion, UpdateConfigModel? config)? initial,
    TResult Function(String currentVersion, UpdateConfigModel? config)? loading,
    TResult Function(String currentVersion, UpdateConfigModel config)? success,
    TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppUpdateInitial value) initial,
    required TResult Function(AppUpdateLoading value) loading,
    required TResult Function(AppUpdateSuccess value) success,
    required TResult Function(AppUpdateFailure value) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppUpdateInitial value)? initial,
    TResult? Function(AppUpdateLoading value)? loading,
    TResult? Function(AppUpdateSuccess value)? success,
    TResult? Function(AppUpdateFailure value)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppUpdateInitial value)? initial,
    TResult Function(AppUpdateLoading value)? loading,
    TResult Function(AppUpdateSuccess value)? success,
    TResult Function(AppUpdateFailure value)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUpdateStateCopyWith<AppUpdateState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUpdateStateCopyWith<$Res> {
  factory $AppUpdateStateCopyWith(
    AppUpdateState value,
    $Res Function(AppUpdateState) then,
  ) = _$AppUpdateStateCopyWithImpl<$Res, AppUpdateState>;
  @useResult
  $Res call({String currentVersion, UpdateConfigModel config});

  $UpdateConfigModelCopyWith<$Res>? get config;
}

/// @nodoc
class _$AppUpdateStateCopyWithImpl<$Res, $Val extends AppUpdateState>
    implements $AppUpdateStateCopyWith<$Res> {
  _$AppUpdateStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentVersion = null, Object? config = null}) {
    return _then(
      _value.copyWith(
            currentVersion: null == currentVersion
                ? _value.currentVersion
                : currentVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            config: null == config
                ? _value.config!
                : config // ignore: cast_nullable_to_non_nullable
                      as UpdateConfigModel,
          )
          as $Val,
    );
  }

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateConfigModelCopyWith<$Res>? get config {
    if (_value.config == null) {
      return null;
    }

    return $UpdateConfigModelCopyWith<$Res>(_value.config!, (value) {
      return _then(_value.copyWith(config: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppUpdateInitialImplCopyWith<$Res>
    implements $AppUpdateStateCopyWith<$Res> {
  factory _$$AppUpdateInitialImplCopyWith(
    _$AppUpdateInitialImpl value,
    $Res Function(_$AppUpdateInitialImpl) then,
  ) = __$$AppUpdateInitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentVersion, UpdateConfigModel? config});

  @override
  $UpdateConfigModelCopyWith<$Res>? get config;
}

/// @nodoc
class __$$AppUpdateInitialImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$AppUpdateInitialImpl>
    implements _$$AppUpdateInitialImplCopyWith<$Res> {
  __$$AppUpdateInitialImplCopyWithImpl(
    _$AppUpdateInitialImpl _value,
    $Res Function(_$AppUpdateInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentVersion = null, Object? config = freezed}) {
    return _then(
      _$AppUpdateInitialImpl(
        currentVersion: null == currentVersion
            ? _value.currentVersion
            : currentVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        config: freezed == config
            ? _value.config
            : config // ignore: cast_nullable_to_non_nullable
                  as UpdateConfigModel?,
      ),
    );
  }
}

/// @nodoc

class _$AppUpdateInitialImpl extends AppUpdateInitial
    with DiagnosticableTreeMixin {
  const _$AppUpdateInitialImpl({this.currentVersion = '0.0.0+0', this.config})
    : super._();

  @override
  @JsonKey()
  final String currentVersion;
  @override
  final UpdateConfigModel? config;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppUpdateState.initial(currentVersion: $currentVersion, config: $config)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppUpdateState.initial'))
      ..add(DiagnosticsProperty('currentVersion', currentVersion))
      ..add(DiagnosticsProperty('config', config));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUpdateInitialImpl &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentVersion, config);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUpdateInitialImplCopyWith<_$AppUpdateInitialImpl> get copyWith =>
      __$$AppUpdateInitialImplCopyWithImpl<_$AppUpdateInitialImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    initial,
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    loading,
    required TResult Function(String currentVersion, UpdateConfigModel config)
    success,
    required TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )
    failure,
  }) {
    return initial(currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    initial,
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    loading,
    TResult? Function(String currentVersion, UpdateConfigModel config)? success,
    TResult? Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
  }) {
    return initial?.call(currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String currentVersion, UpdateConfigModel? config)? initial,
    TResult Function(String currentVersion, UpdateConfigModel? config)? loading,
    TResult Function(String currentVersion, UpdateConfigModel config)? success,
    TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(currentVersion, config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppUpdateInitial value) initial,
    required TResult Function(AppUpdateLoading value) loading,
    required TResult Function(AppUpdateSuccess value) success,
    required TResult Function(AppUpdateFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppUpdateInitial value)? initial,
    TResult? Function(AppUpdateLoading value)? loading,
    TResult? Function(AppUpdateSuccess value)? success,
    TResult? Function(AppUpdateFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppUpdateInitial value)? initial,
    TResult Function(AppUpdateLoading value)? loading,
    TResult Function(AppUpdateSuccess value)? success,
    TResult Function(AppUpdateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AppUpdateInitial extends AppUpdateState {
  const factory AppUpdateInitial({
    final String currentVersion,
    final UpdateConfigModel? config,
  }) = _$AppUpdateInitialImpl;
  const AppUpdateInitial._() : super._();

  @override
  String get currentVersion;
  @override
  UpdateConfigModel? get config;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUpdateInitialImplCopyWith<_$AppUpdateInitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppUpdateLoadingImplCopyWith<$Res>
    implements $AppUpdateStateCopyWith<$Res> {
  factory _$$AppUpdateLoadingImplCopyWith(
    _$AppUpdateLoadingImpl value,
    $Res Function(_$AppUpdateLoadingImpl) then,
  ) = __$$AppUpdateLoadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentVersion, UpdateConfigModel? config});

  @override
  $UpdateConfigModelCopyWith<$Res>? get config;
}

/// @nodoc
class __$$AppUpdateLoadingImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$AppUpdateLoadingImpl>
    implements _$$AppUpdateLoadingImplCopyWith<$Res> {
  __$$AppUpdateLoadingImplCopyWithImpl(
    _$AppUpdateLoadingImpl _value,
    $Res Function(_$AppUpdateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentVersion = null, Object? config = freezed}) {
    return _then(
      _$AppUpdateLoadingImpl(
        currentVersion: null == currentVersion
            ? _value.currentVersion
            : currentVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        config: freezed == config
            ? _value.config
            : config // ignore: cast_nullable_to_non_nullable
                  as UpdateConfigModel?,
      ),
    );
  }
}

/// @nodoc

class _$AppUpdateLoadingImpl extends AppUpdateLoading
    with DiagnosticableTreeMixin {
  const _$AppUpdateLoadingImpl({this.currentVersion = '0.0.0+0', this.config})
    : super._();

  @override
  @JsonKey()
  final String currentVersion;
  @override
  final UpdateConfigModel? config;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppUpdateState.loading(currentVersion: $currentVersion, config: $config)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppUpdateState.loading'))
      ..add(DiagnosticsProperty('currentVersion', currentVersion))
      ..add(DiagnosticsProperty('config', config));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUpdateLoadingImpl &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentVersion, config);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUpdateLoadingImplCopyWith<_$AppUpdateLoadingImpl> get copyWith =>
      __$$AppUpdateLoadingImplCopyWithImpl<_$AppUpdateLoadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    initial,
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    loading,
    required TResult Function(String currentVersion, UpdateConfigModel config)
    success,
    required TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )
    failure,
  }) {
    return loading(currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    initial,
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    loading,
    TResult? Function(String currentVersion, UpdateConfigModel config)? success,
    TResult? Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
  }) {
    return loading?.call(currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String currentVersion, UpdateConfigModel? config)? initial,
    TResult Function(String currentVersion, UpdateConfigModel? config)? loading,
    TResult Function(String currentVersion, UpdateConfigModel config)? success,
    TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(currentVersion, config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppUpdateInitial value) initial,
    required TResult Function(AppUpdateLoading value) loading,
    required TResult Function(AppUpdateSuccess value) success,
    required TResult Function(AppUpdateFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppUpdateInitial value)? initial,
    TResult? Function(AppUpdateLoading value)? loading,
    TResult? Function(AppUpdateSuccess value)? success,
    TResult? Function(AppUpdateFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppUpdateInitial value)? initial,
    TResult Function(AppUpdateLoading value)? loading,
    TResult Function(AppUpdateSuccess value)? success,
    TResult Function(AppUpdateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AppUpdateLoading extends AppUpdateState {
  const factory AppUpdateLoading({
    final String currentVersion,
    final UpdateConfigModel? config,
  }) = _$AppUpdateLoadingImpl;
  const AppUpdateLoading._() : super._();

  @override
  String get currentVersion;
  @override
  UpdateConfigModel? get config;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUpdateLoadingImplCopyWith<_$AppUpdateLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppUpdateSuccessImplCopyWith<$Res>
    implements $AppUpdateStateCopyWith<$Res> {
  factory _$$AppUpdateSuccessImplCopyWith(
    _$AppUpdateSuccessImpl value,
    $Res Function(_$AppUpdateSuccessImpl) then,
  ) = __$$AppUpdateSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentVersion, UpdateConfigModel config});

  @override
  $UpdateConfigModelCopyWith<$Res> get config;
}

/// @nodoc
class __$$AppUpdateSuccessImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$AppUpdateSuccessImpl>
    implements _$$AppUpdateSuccessImplCopyWith<$Res> {
  __$$AppUpdateSuccessImplCopyWithImpl(
    _$AppUpdateSuccessImpl _value,
    $Res Function(_$AppUpdateSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentVersion = null, Object? config = null}) {
    return _then(
      _$AppUpdateSuccessImpl(
        currentVersion: null == currentVersion
            ? _value.currentVersion
            : currentVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        config: null == config
            ? _value.config
            : config // ignore: cast_nullable_to_non_nullable
                  as UpdateConfigModel,
      ),
    );
  }

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateConfigModelCopyWith<$Res> get config {
    return $UpdateConfigModelCopyWith<$Res>(_value.config, (value) {
      return _then(_value.copyWith(config: value));
    });
  }
}

/// @nodoc

class _$AppUpdateSuccessImpl extends AppUpdateSuccess
    with DiagnosticableTreeMixin {
  const _$AppUpdateSuccessImpl({
    required this.currentVersion,
    required this.config,
  }) : super._();

  @override
  final String currentVersion;
  @override
  final UpdateConfigModel config;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppUpdateState.success(currentVersion: $currentVersion, config: $config)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppUpdateState.success'))
      ..add(DiagnosticsProperty('currentVersion', currentVersion))
      ..add(DiagnosticsProperty('config', config));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUpdateSuccessImpl &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentVersion, config);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUpdateSuccessImplCopyWith<_$AppUpdateSuccessImpl> get copyWith =>
      __$$AppUpdateSuccessImplCopyWithImpl<_$AppUpdateSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    initial,
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    loading,
    required TResult Function(String currentVersion, UpdateConfigModel config)
    success,
    required TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )
    failure,
  }) {
    return success(currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    initial,
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    loading,
    TResult? Function(String currentVersion, UpdateConfigModel config)? success,
    TResult? Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
  }) {
    return success?.call(currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String currentVersion, UpdateConfigModel? config)? initial,
    TResult Function(String currentVersion, UpdateConfigModel? config)? loading,
    TResult Function(String currentVersion, UpdateConfigModel config)? success,
    TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(currentVersion, config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppUpdateInitial value) initial,
    required TResult Function(AppUpdateLoading value) loading,
    required TResult Function(AppUpdateSuccess value) success,
    required TResult Function(AppUpdateFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppUpdateInitial value)? initial,
    TResult? Function(AppUpdateLoading value)? loading,
    TResult? Function(AppUpdateSuccess value)? success,
    TResult? Function(AppUpdateFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppUpdateInitial value)? initial,
    TResult Function(AppUpdateLoading value)? loading,
    TResult Function(AppUpdateSuccess value)? success,
    TResult Function(AppUpdateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class AppUpdateSuccess extends AppUpdateState {
  const factory AppUpdateSuccess({
    required final String currentVersion,
    required final UpdateConfigModel config,
  }) = _$AppUpdateSuccessImpl;
  const AppUpdateSuccess._() : super._();

  @override
  String get currentVersion;
  @override
  UpdateConfigModel get config;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUpdateSuccessImplCopyWith<_$AppUpdateSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppUpdateFailureImplCopyWith<$Res>
    implements $AppUpdateStateCopyWith<$Res> {
  factory _$$AppUpdateFailureImplCopyWith(
    _$AppUpdateFailureImpl value,
    $Res Function(_$AppUpdateFailureImpl) then,
  ) = __$$AppUpdateFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String errorMessage,
    String currentVersion,
    UpdateConfigModel? config,
  });

  @override
  $UpdateConfigModelCopyWith<$Res>? get config;
}

/// @nodoc
class __$$AppUpdateFailureImplCopyWithImpl<$Res>
    extends _$AppUpdateStateCopyWithImpl<$Res, _$AppUpdateFailureImpl>
    implements _$$AppUpdateFailureImplCopyWith<$Res> {
  __$$AppUpdateFailureImplCopyWithImpl(
    _$AppUpdateFailureImpl _value,
    $Res Function(_$AppUpdateFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
    Object? currentVersion = null,
    Object? config = freezed,
  }) {
    return _then(
      _$AppUpdateFailureImpl(
        errorMessage: null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        currentVersion: null == currentVersion
            ? _value.currentVersion
            : currentVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        config: freezed == config
            ? _value.config
            : config // ignore: cast_nullable_to_non_nullable
                  as UpdateConfigModel?,
      ),
    );
  }
}

/// @nodoc

class _$AppUpdateFailureImpl extends AppUpdateFailure
    with DiagnosticableTreeMixin {
  const _$AppUpdateFailureImpl({
    required this.errorMessage,
    this.currentVersion = '0.0.0+0',
    this.config,
  }) : super._();

  @override
  final String errorMessage;
  @override
  @JsonKey()
  final String currentVersion;
  @override
  final UpdateConfigModel? config;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppUpdateState.failure(errorMessage: $errorMessage, currentVersion: $currentVersion, config: $config)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppUpdateState.failure'))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('currentVersion', currentVersion))
      ..add(DiagnosticsProperty('config', config));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUpdateFailureImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.config, config) || other.config == config));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, errorMessage, currentVersion, config);

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUpdateFailureImplCopyWith<_$AppUpdateFailureImpl> get copyWith =>
      __$$AppUpdateFailureImplCopyWithImpl<_$AppUpdateFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    initial,
    required TResult Function(String currentVersion, UpdateConfigModel? config)
    loading,
    required TResult Function(String currentVersion, UpdateConfigModel config)
    success,
    required TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )
    failure,
  }) {
    return failure(errorMessage, currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    initial,
    TResult? Function(String currentVersion, UpdateConfigModel? config)?
    loading,
    TResult? Function(String currentVersion, UpdateConfigModel config)? success,
    TResult? Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
  }) {
    return failure?.call(errorMessage, currentVersion, config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String currentVersion, UpdateConfigModel? config)? initial,
    TResult Function(String currentVersion, UpdateConfigModel? config)? loading,
    TResult Function(String currentVersion, UpdateConfigModel config)? success,
    TResult Function(
      String errorMessage,
      String currentVersion,
      UpdateConfigModel? config,
    )?
    failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(errorMessage, currentVersion, config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppUpdateInitial value) initial,
    required TResult Function(AppUpdateLoading value) loading,
    required TResult Function(AppUpdateSuccess value) success,
    required TResult Function(AppUpdateFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppUpdateInitial value)? initial,
    TResult? Function(AppUpdateLoading value)? loading,
    TResult? Function(AppUpdateSuccess value)? success,
    TResult? Function(AppUpdateFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppUpdateInitial value)? initial,
    TResult Function(AppUpdateLoading value)? loading,
    TResult Function(AppUpdateSuccess value)? success,
    TResult Function(AppUpdateFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class AppUpdateFailure extends AppUpdateState {
  const factory AppUpdateFailure({
    required final String errorMessage,
    final String currentVersion,
    final UpdateConfigModel? config,
  }) = _$AppUpdateFailureImpl;
  const AppUpdateFailure._() : super._();

  String get errorMessage;
  @override
  String get currentVersion;
  @override
  UpdateConfigModel? get config;

  /// Create a copy of AppUpdateState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUpdateFailureImplCopyWith<_$AppUpdateFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
