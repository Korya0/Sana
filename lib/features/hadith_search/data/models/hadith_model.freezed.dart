// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HadithModel {
  String get hadithContent => throw _privateConstructorUsedError;
  String? get narrator => throw _privateConstructorUsedError;
  String? get scholar => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get page => throw _privateConstructorUsedError;
  String? get judgment => throw _privateConstructorUsedError;

  /// Create a copy of HadithModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HadithModelCopyWith<HadithModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HadithModelCopyWith<$Res> {
  factory $HadithModelCopyWith(
    HadithModel value,
    $Res Function(HadithModel) then,
  ) = _$HadithModelCopyWithImpl<$Res, HadithModel>;
  @useResult
  $Res call({
    String hadithContent,
    String? narrator,
    String? scholar,
    String? source,
    String? page,
    String? judgment,
  });
}

/// @nodoc
class _$HadithModelCopyWithImpl<$Res, $Val extends HadithModel>
    implements $HadithModelCopyWith<$Res> {
  _$HadithModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HadithModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hadithContent = null,
    Object? narrator = freezed,
    Object? scholar = freezed,
    Object? source = freezed,
    Object? page = freezed,
    Object? judgment = freezed,
  }) {
    return _then(
      _value.copyWith(
            hadithContent: null == hadithContent
                ? _value.hadithContent
                : hadithContent // ignore: cast_nullable_to_non_nullable
                      as String,
            narrator: freezed == narrator
                ? _value.narrator
                : narrator // ignore: cast_nullable_to_non_nullable
                      as String?,
            scholar: freezed == scholar
                ? _value.scholar
                : scholar // ignore: cast_nullable_to_non_nullable
                      as String?,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
            page: freezed == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as String?,
            judgment: freezed == judgment
                ? _value.judgment
                : judgment // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HadithModelImplCopyWith<$Res>
    implements $HadithModelCopyWith<$Res> {
  factory _$$HadithModelImplCopyWith(
    _$HadithModelImpl value,
    $Res Function(_$HadithModelImpl) then,
  ) = __$$HadithModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String hadithContent,
    String? narrator,
    String? scholar,
    String? source,
    String? page,
    String? judgment,
  });
}

/// @nodoc
class __$$HadithModelImplCopyWithImpl<$Res>
    extends _$HadithModelCopyWithImpl<$Res, _$HadithModelImpl>
    implements _$$HadithModelImplCopyWith<$Res> {
  __$$HadithModelImplCopyWithImpl(
    _$HadithModelImpl _value,
    $Res Function(_$HadithModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HadithModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hadithContent = null,
    Object? narrator = freezed,
    Object? scholar = freezed,
    Object? source = freezed,
    Object? page = freezed,
    Object? judgment = freezed,
  }) {
    return _then(
      _$HadithModelImpl(
        hadithContent: null == hadithContent
            ? _value.hadithContent
            : hadithContent // ignore: cast_nullable_to_non_nullable
                  as String,
        narrator: freezed == narrator
            ? _value.narrator
            : narrator // ignore: cast_nullable_to_non_nullable
                  as String?,
        scholar: freezed == scholar
            ? _value.scholar
            : scholar // ignore: cast_nullable_to_non_nullable
                  as String?,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        page: freezed == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as String?,
        judgment: freezed == judgment
            ? _value.judgment
            : judgment // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$HadithModelImpl extends _HadithModel {
  const _$HadithModelImpl({
    required this.hadithContent,
    this.narrator,
    this.scholar,
    this.source,
    this.page,
    this.judgment,
  }) : super._();

  @override
  final String hadithContent;
  @override
  final String? narrator;
  @override
  final String? scholar;
  @override
  final String? source;
  @override
  final String? page;
  @override
  final String? judgment;

  @override
  String toString() {
    return 'HadithModel(hadithContent: $hadithContent, narrator: $narrator, scholar: $scholar, source: $source, page: $page, judgment: $judgment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HadithModelImpl &&
            (identical(other.hadithContent, hadithContent) ||
                other.hadithContent == hadithContent) &&
            (identical(other.narrator, narrator) ||
                other.narrator == narrator) &&
            (identical(other.scholar, scholar) || other.scholar == scholar) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.judgment, judgment) ||
                other.judgment == judgment));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    hadithContent,
    narrator,
    scholar,
    source,
    page,
    judgment,
  );

  /// Create a copy of HadithModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HadithModelImplCopyWith<_$HadithModelImpl> get copyWith =>
      __$$HadithModelImplCopyWithImpl<_$HadithModelImpl>(this, _$identity);
}

abstract class _HadithModel extends HadithModel {
  const factory _HadithModel({
    required final String hadithContent,
    final String? narrator,
    final String? scholar,
    final String? source,
    final String? page,
    final String? judgment,
  }) = _$HadithModelImpl;
  const _HadithModel._() : super._();

  @override
  String get hadithContent;
  @override
  String? get narrator;
  @override
  String? get scholar;
  @override
  String? get source;
  @override
  String? get page;
  @override
  String? get judgment;

  /// Create a copy of HadithModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HadithModelImplCopyWith<_$HadithModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
