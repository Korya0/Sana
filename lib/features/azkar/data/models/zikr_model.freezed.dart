// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zikr_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ZikrModel {
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String? get subText => throw _privateConstructorUsedError;

  /// Create a copy of ZikrModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZikrModelCopyWith<ZikrModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZikrModelCopyWith<$Res> {
  factory $ZikrModelCopyWith(ZikrModel value, $Res Function(ZikrModel) then) =
      _$ZikrModelCopyWithImpl<$Res, ZikrModel>;
  @useResult
  $Res call({int id, String text, int count, String? subText});
}

/// @nodoc
class _$ZikrModelCopyWithImpl<$Res, $Val extends ZikrModel>
    implements $ZikrModelCopyWith<$Res> {
  _$ZikrModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZikrModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? count = null,
    Object? subText = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            subText: freezed == subText
                ? _value.subText
                : subText // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ZikrModelImplCopyWith<$Res>
    implements $ZikrModelCopyWith<$Res> {
  factory _$$ZikrModelImplCopyWith(
    _$ZikrModelImpl value,
    $Res Function(_$ZikrModelImpl) then,
  ) = __$$ZikrModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String text, int count, String? subText});
}

/// @nodoc
class __$$ZikrModelImplCopyWithImpl<$Res>
    extends _$ZikrModelCopyWithImpl<$Res, _$ZikrModelImpl>
    implements _$$ZikrModelImplCopyWith<$Res> {
  __$$ZikrModelImplCopyWithImpl(
    _$ZikrModelImpl _value,
    $Res Function(_$ZikrModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ZikrModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? count = null,
    Object? subText = freezed,
  }) {
    return _then(
      _$ZikrModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        subText: freezed == subText
            ? _value.subText
            : subText // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ZikrModelImpl implements _ZikrModel {
  const _$ZikrModelImpl({
    required this.id,
    required this.text,
    required this.count,
    this.subText,
  });

  @override
  final int id;
  @override
  final String text;
  @override
  final int count;
  @override
  final String? subText;

  @override
  String toString() {
    return 'ZikrModel(id: $id, text: $text, count: $count, subText: $subText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZikrModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.subText, subText) || other.subText == subText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, text, count, subText);

  /// Create a copy of ZikrModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZikrModelImplCopyWith<_$ZikrModelImpl> get copyWith =>
      __$$ZikrModelImplCopyWithImpl<_$ZikrModelImpl>(this, _$identity);
}

abstract class _ZikrModel implements ZikrModel {
  const factory _ZikrModel({
    required final int id,
    required final String text,
    required final int count,
    final String? subText,
  }) = _$ZikrModelImpl;

  @override
  int get id;
  @override
  String get text;
  @override
  int get count;
  @override
  String? get subText;

  /// Create a copy of ZikrModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZikrModelImplCopyWith<_$ZikrModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
