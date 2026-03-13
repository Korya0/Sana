// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UpdateConfigModel {
  String get latestVersion => throw _privateConstructorUsedError;
  bool get isForceUpdate => throw _privateConstructorUsedError;
  String get updateUrl => throw _privateConstructorUsedError;
  String get updateUrlIos => throw _privateConstructorUsedError;
  String? get updateMessage => throw _privateConstructorUsedError;

  /// Create a copy of UpdateConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateConfigModelCopyWith<UpdateConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateConfigModelCopyWith<$Res> {
  factory $UpdateConfigModelCopyWith(
    UpdateConfigModel value,
    $Res Function(UpdateConfigModel) then,
  ) = _$UpdateConfigModelCopyWithImpl<$Res, UpdateConfigModel>;
  @useResult
  $Res call({
    String latestVersion,
    bool isForceUpdate,
    String updateUrl,
    String updateUrlIos,
    String? updateMessage,
  });
}

/// @nodoc
class _$UpdateConfigModelCopyWithImpl<$Res, $Val extends UpdateConfigModel>
    implements $UpdateConfigModelCopyWith<$Res> {
  _$UpdateConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestVersion = null,
    Object? isForceUpdate = null,
    Object? updateUrl = null,
    Object? updateUrlIos = null,
    Object? updateMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            latestVersion: null == latestVersion
                ? _value.latestVersion
                : latestVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            isForceUpdate: null == isForceUpdate
                ? _value.isForceUpdate
                : isForceUpdate // ignore: cast_nullable_to_non_nullable
                      as bool,
            updateUrl: null == updateUrl
                ? _value.updateUrl
                : updateUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            updateUrlIos: null == updateUrlIos
                ? _value.updateUrlIos
                : updateUrlIos // ignore: cast_nullable_to_non_nullable
                      as String,
            updateMessage: freezed == updateMessage
                ? _value.updateMessage
                : updateMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateConfigModelImplCopyWith<$Res>
    implements $UpdateConfigModelCopyWith<$Res> {
  factory _$$UpdateConfigModelImplCopyWith(
    _$UpdateConfigModelImpl value,
    $Res Function(_$UpdateConfigModelImpl) then,
  ) = __$$UpdateConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String latestVersion,
    bool isForceUpdate,
    String updateUrl,
    String updateUrlIos,
    String? updateMessage,
  });
}

/// @nodoc
class __$$UpdateConfigModelImplCopyWithImpl<$Res>
    extends _$UpdateConfigModelCopyWithImpl<$Res, _$UpdateConfigModelImpl>
    implements _$$UpdateConfigModelImplCopyWith<$Res> {
  __$$UpdateConfigModelImplCopyWithImpl(
    _$UpdateConfigModelImpl _value,
    $Res Function(_$UpdateConfigModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestVersion = null,
    Object? isForceUpdate = null,
    Object? updateUrl = null,
    Object? updateUrlIos = null,
    Object? updateMessage = freezed,
  }) {
    return _then(
      _$UpdateConfigModelImpl(
        latestVersion: null == latestVersion
            ? _value.latestVersion
            : latestVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        isForceUpdate: null == isForceUpdate
            ? _value.isForceUpdate
            : isForceUpdate // ignore: cast_nullable_to_non_nullable
                  as bool,
        updateUrl: null == updateUrl
            ? _value.updateUrl
            : updateUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        updateUrlIos: null == updateUrlIos
            ? _value.updateUrlIos
            : updateUrlIos // ignore: cast_nullable_to_non_nullable
                  as String,
        updateMessage: freezed == updateMessage
            ? _value.updateMessage
            : updateMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateConfigModelImpl extends _UpdateConfigModel {
  const _$UpdateConfigModelImpl({
    required this.latestVersion,
    required this.isForceUpdate,
    required this.updateUrl,
    this.updateUrlIos = '',
    this.updateMessage,
  }) : super._();

  @override
  final String latestVersion;
  @override
  final bool isForceUpdate;
  @override
  final String updateUrl;
  @override
  @JsonKey()
  final String updateUrlIos;
  @override
  final String? updateMessage;

  @override
  String toString() {
    return 'UpdateConfigModel(latestVersion: $latestVersion, isForceUpdate: $isForceUpdate, updateUrl: $updateUrl, updateUrlIos: $updateUrlIos, updateMessage: $updateMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateConfigModelImpl &&
            (identical(other.latestVersion, latestVersion) ||
                other.latestVersion == latestVersion) &&
            (identical(other.isForceUpdate, isForceUpdate) ||
                other.isForceUpdate == isForceUpdate) &&
            (identical(other.updateUrl, updateUrl) ||
                other.updateUrl == updateUrl) &&
            (identical(other.updateUrlIos, updateUrlIos) ||
                other.updateUrlIos == updateUrlIos) &&
            (identical(other.updateMessage, updateMessage) ||
                other.updateMessage == updateMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    latestVersion,
    isForceUpdate,
    updateUrl,
    updateUrlIos,
    updateMessage,
  );

  /// Create a copy of UpdateConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateConfigModelImplCopyWith<_$UpdateConfigModelImpl> get copyWith =>
      __$$UpdateConfigModelImplCopyWithImpl<_$UpdateConfigModelImpl>(
        this,
        _$identity,
      );
}

abstract class _UpdateConfigModel extends UpdateConfigModel {
  const factory _UpdateConfigModel({
    required final String latestVersion,
    required final bool isForceUpdate,
    required final String updateUrl,
    final String updateUrlIos,
    final String? updateMessage,
  }) = _$UpdateConfigModelImpl;
  const _UpdateConfigModel._() : super._();

  @override
  String get latestVersion;
  @override
  bool get isForceUpdate;
  @override
  String get updateUrl;
  @override
  String get updateUrlIos;
  @override
  String? get updateMessage;

  /// Create a copy of UpdateConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateConfigModelImplCopyWith<_$UpdateConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
