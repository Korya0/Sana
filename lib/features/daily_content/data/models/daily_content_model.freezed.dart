// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DailyContentModel {
  String get content => throw _privateConstructorUsedError;
  DailyContentType get category => throw _privateConstructorUsedError;
  String? get header => throw _privateConstructorUsedError;
  String? get attribution => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;

  /// Create a copy of DailyContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyContentModelCopyWith<DailyContentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyContentModelCopyWith<$Res> {
  factory $DailyContentModelCopyWith(
    DailyContentModel value,
    $Res Function(DailyContentModel) then,
  ) = _$DailyContentModelCopyWithImpl<$Res, DailyContentModel>;
  @useResult
  $Res call({
    String content,
    DailyContentType category,
    String? header,
    String? attribution,
    String? explanation,
  });
}

/// @nodoc
class _$DailyContentModelCopyWithImpl<$Res, $Val extends DailyContentModel>
    implements $DailyContentModelCopyWith<$Res> {
  _$DailyContentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? category = null,
    Object? header = freezed,
    Object? attribution = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _value.copyWith(
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as DailyContentType,
            header: freezed == header
                ? _value.header
                : header // ignore: cast_nullable_to_non_nullable
                      as String?,
            attribution: freezed == attribution
                ? _value.attribution
                : attribution // ignore: cast_nullable_to_non_nullable
                      as String?,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyContentModelImplCopyWith<$Res>
    implements $DailyContentModelCopyWith<$Res> {
  factory _$$DailyContentModelImplCopyWith(
    _$DailyContentModelImpl value,
    $Res Function(_$DailyContentModelImpl) then,
  ) = __$$DailyContentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String content,
    DailyContentType category,
    String? header,
    String? attribution,
    String? explanation,
  });
}

/// @nodoc
class __$$DailyContentModelImplCopyWithImpl<$Res>
    extends _$DailyContentModelCopyWithImpl<$Res, _$DailyContentModelImpl>
    implements _$$DailyContentModelImplCopyWith<$Res> {
  __$$DailyContentModelImplCopyWithImpl(
    _$DailyContentModelImpl _value,
    $Res Function(_$DailyContentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? category = null,
    Object? header = freezed,
    Object? attribution = freezed,
    Object? explanation = freezed,
  }) {
    return _then(
      _$DailyContentModelImpl(
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as DailyContentType,
        header: freezed == header
            ? _value.header
            : header // ignore: cast_nullable_to_non_nullable
                  as String?,
        attribution: freezed == attribution
            ? _value.attribution
            : attribution // ignore: cast_nullable_to_non_nullable
                  as String?,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DailyContentModelImpl extends _DailyContentModel {
  const _$DailyContentModelImpl({
    required this.content,
    required this.category,
    this.header,
    this.attribution,
    this.explanation,
  }) : super._();

  @override
  final String content;
  @override
  final DailyContentType category;
  @override
  final String? header;
  @override
  final String? attribution;
  @override
  final String? explanation;

  @override
  String toString() {
    return 'DailyContentModel(content: $content, category: $category, header: $header, attribution: $attribution, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyContentModelImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.header, header) || other.header == header) &&
            (identical(other.attribution, attribution) ||
                other.attribution == attribution) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    content,
    category,
    header,
    attribution,
    explanation,
  );

  /// Create a copy of DailyContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyContentModelImplCopyWith<_$DailyContentModelImpl> get copyWith =>
      __$$DailyContentModelImplCopyWithImpl<_$DailyContentModelImpl>(
        this,
        _$identity,
      );
}

abstract class _DailyContentModel extends DailyContentModel {
  const factory _DailyContentModel({
    required final String content,
    required final DailyContentType category,
    final String? header,
    final String? attribution,
    final String? explanation,
  }) = _$DailyContentModelImpl;
  const _DailyContentModel._() : super._();

  @override
  String get content;
  @override
  DailyContentType get category;
  @override
  String? get header;
  @override
  String? get attribution;
  @override
  String? get explanation;

  /// Create a copy of DailyContentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyContentModelImplCopyWith<_$DailyContentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
