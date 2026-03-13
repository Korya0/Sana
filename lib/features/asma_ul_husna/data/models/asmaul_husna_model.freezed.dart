// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asmaul_husna_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AsmaulHusnaModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get meaningBrief => throw _privateConstructorUsedError;
  String get meaningDetailed => throw _privateConstructorUsedError;

  /// Create a copy of AsmaulHusnaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AsmaulHusnaModelCopyWith<AsmaulHusnaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsmaulHusnaModelCopyWith<$Res> {
  factory $AsmaulHusnaModelCopyWith(
    AsmaulHusnaModel value,
    $Res Function(AsmaulHusnaModel) then,
  ) = _$AsmaulHusnaModelCopyWithImpl<$Res, AsmaulHusnaModel>;
  @useResult
  $Res call({int id, String name, String meaningBrief, String meaningDetailed});
}

/// @nodoc
class _$AsmaulHusnaModelCopyWithImpl<$Res, $Val extends AsmaulHusnaModel>
    implements $AsmaulHusnaModelCopyWith<$Res> {
  _$AsmaulHusnaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AsmaulHusnaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? meaningBrief = null,
    Object? meaningDetailed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            meaningBrief: null == meaningBrief
                ? _value.meaningBrief
                : meaningBrief // ignore: cast_nullable_to_non_nullable
                      as String,
            meaningDetailed: null == meaningDetailed
                ? _value.meaningDetailed
                : meaningDetailed // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AsmaulHusnaModelImplCopyWith<$Res>
    implements $AsmaulHusnaModelCopyWith<$Res> {
  factory _$$AsmaulHusnaModelImplCopyWith(
    _$AsmaulHusnaModelImpl value,
    $Res Function(_$AsmaulHusnaModelImpl) then,
  ) = __$$AsmaulHusnaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String meaningBrief, String meaningDetailed});
}

/// @nodoc
class __$$AsmaulHusnaModelImplCopyWithImpl<$Res>
    extends _$AsmaulHusnaModelCopyWithImpl<$Res, _$AsmaulHusnaModelImpl>
    implements _$$AsmaulHusnaModelImplCopyWith<$Res> {
  __$$AsmaulHusnaModelImplCopyWithImpl(
    _$AsmaulHusnaModelImpl _value,
    $Res Function(_$AsmaulHusnaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AsmaulHusnaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? meaningBrief = null,
    Object? meaningDetailed = null,
  }) {
    return _then(
      _$AsmaulHusnaModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        meaningBrief: null == meaningBrief
            ? _value.meaningBrief
            : meaningBrief // ignore: cast_nullable_to_non_nullable
                  as String,
        meaningDetailed: null == meaningDetailed
            ? _value.meaningDetailed
            : meaningDetailed // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AsmaulHusnaModelImpl implements _AsmaulHusnaModel {
  const _$AsmaulHusnaModelImpl({
    required this.id,
    required this.name,
    required this.meaningBrief,
    required this.meaningDetailed,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final String meaningBrief;
  @override
  final String meaningDetailed;

  @override
  String toString() {
    return 'AsmaulHusnaModel(id: $id, name: $name, meaningBrief: $meaningBrief, meaningDetailed: $meaningDetailed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsmaulHusnaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.meaningBrief, meaningBrief) ||
                other.meaningBrief == meaningBrief) &&
            (identical(other.meaningDetailed, meaningDetailed) ||
                other.meaningDetailed == meaningDetailed));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, meaningBrief, meaningDetailed);

  /// Create a copy of AsmaulHusnaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsmaulHusnaModelImplCopyWith<_$AsmaulHusnaModelImpl> get copyWith =>
      __$$AsmaulHusnaModelImplCopyWithImpl<_$AsmaulHusnaModelImpl>(
        this,
        _$identity,
      );
}

abstract class _AsmaulHusnaModel implements AsmaulHusnaModel {
  const factory _AsmaulHusnaModel({
    required final int id,
    required final String name,
    required final String meaningBrief,
    required final String meaningDetailed,
  }) = _$AsmaulHusnaModelImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String get meaningBrief;
  @override
  String get meaningDetailed;

  /// Create a copy of AsmaulHusnaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsmaulHusnaModelImplCopyWith<_$AsmaulHusnaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
