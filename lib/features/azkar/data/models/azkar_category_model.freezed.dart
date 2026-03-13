// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'azkar_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AzkarCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<ZikrModel> get array => throw _privateConstructorUsedError;
  IconData get icon => throw _privateConstructorUsedError;

  /// Create a copy of AzkarCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AzkarCategoryModelCopyWith<AzkarCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AzkarCategoryModelCopyWith<$Res> {
  factory $AzkarCategoryModelCopyWith(
    AzkarCategoryModel value,
    $Res Function(AzkarCategoryModel) then,
  ) = _$AzkarCategoryModelCopyWithImpl<$Res, AzkarCategoryModel>;
  @useResult
  $Res call({String id, String category, List<ZikrModel> array, IconData icon});
}

/// @nodoc
class _$AzkarCategoryModelCopyWithImpl<$Res, $Val extends AzkarCategoryModel>
    implements $AzkarCategoryModelCopyWith<$Res> {
  _$AzkarCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AzkarCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? array = null,
    Object? icon = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            array: null == array
                ? _value.array
                : array // ignore: cast_nullable_to_non_nullable
                      as List<ZikrModel>,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as IconData,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AzkarCategoryModelImplCopyWith<$Res>
    implements $AzkarCategoryModelCopyWith<$Res> {
  factory _$$AzkarCategoryModelImplCopyWith(
    _$AzkarCategoryModelImpl value,
    $Res Function(_$AzkarCategoryModelImpl) then,
  ) = __$$AzkarCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String category, List<ZikrModel> array, IconData icon});
}

/// @nodoc
class __$$AzkarCategoryModelImplCopyWithImpl<$Res>
    extends _$AzkarCategoryModelCopyWithImpl<$Res, _$AzkarCategoryModelImpl>
    implements _$$AzkarCategoryModelImplCopyWith<$Res> {
  __$$AzkarCategoryModelImplCopyWithImpl(
    _$AzkarCategoryModelImpl _value,
    $Res Function(_$AzkarCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AzkarCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? array = null,
    Object? icon = null,
  }) {
    return _then(
      _$AzkarCategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        array: null == array
            ? _value._array
            : array // ignore: cast_nullable_to_non_nullable
                  as List<ZikrModel>,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as IconData,
      ),
    );
  }
}

/// @nodoc

class _$AzkarCategoryModelImpl implements _AzkarCategoryModel {
  const _$AzkarCategoryModelImpl({
    required this.id,
    required this.category,
    required final List<ZikrModel> array,
    required this.icon,
  }) : _array = array;

  @override
  final String id;
  @override
  final String category;
  final List<ZikrModel> _array;
  @override
  List<ZikrModel> get array {
    if (_array is EqualUnmodifiableListView) return _array;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_array);
  }

  @override
  final IconData icon;

  @override
  String toString() {
    return 'AzkarCategoryModel(id: $id, category: $category, array: $array, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AzkarCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._array, _array) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    const DeepCollectionEquality().hash(_array),
    icon,
  );

  /// Create a copy of AzkarCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AzkarCategoryModelImplCopyWith<_$AzkarCategoryModelImpl> get copyWith =>
      __$$AzkarCategoryModelImplCopyWithImpl<_$AzkarCategoryModelImpl>(
        this,
        _$identity,
      );
}

abstract class _AzkarCategoryModel implements AzkarCategoryModel {
  const factory _AzkarCategoryModel({
    required final String id,
    required final String category,
    required final List<ZikrModel> array,
    required final IconData icon,
  }) = _$AzkarCategoryModelImpl;

  @override
  String get id;
  @override
  String get category;
  @override
  List<ZikrModel> get array;
  @override
  IconData get icon;

  /// Create a copy of AzkarCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AzkarCategoryModelImplCopyWith<_$AzkarCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
